//
//  HomeViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/5.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import SnapKit

private let reuseID = "SWCollectionViewCell"

class HomeViewController: UIViewController {
    
    lazy var page: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = dataArray?.count ?? 0
        page.pageIndicatorTintColor = cellColor
        page.currentPageIndicatorTintColor = mainColor
        page.currentPage = 0
        return page
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight - 64)
        layout.scrollDirection = .horizontal
        let collectionViewFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 64)
        let collectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: WeatherDataNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: deleteDataNotificationName, object: nil)
        // 设置UI
        setupUI()
        // 若是 push 则添加边缘手势
        if (self.navigationController?.childViewControllers.count)! > 1 {
            DrawerViewController.shared?.addScreenEdgePanGestureRecognizerToView(view: self.collectionView)
        }
    }
    
    // MARK: 移除通知
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        self.title = "SoolyWeather"
        self.navigationController?.navigationBar.titleTextAttributes = {[
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "AdobeClean-Light", size: 18.0)!
            ]}()
        
        // 设置代理属性
        GetWeatherData.shared.delegate = self
        
        /// 设置返回按钮
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        /// 右边item
        let rightBtn = UIButton(type: .custom)
        rightBtn.setTitle("城市", for: .normal)
        rightBtn.sizeToFit()
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        /// 左边item
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "menu"), for: .normal)
        leftBtn.sizeToFit()
        leftBtn.imageView?.contentMode = .scaleAspectFill
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        
        self.view.addSubview(self.collectionView)
        
        // 注册cell
        collectionView.register(UINib(nibName: "SWCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseID)
        
        // 添加pageControl
        view.addSubview(page)
            // 利用SnapKit增加约束
        page.snp.makeConstraints({ make in
            make.top.equalTo(0)
            make.centerX.equalTo(self.view)
            make.width.equalTo(100)
            make.height.equalTo(35)
        })
        
    }
    
    // MARK: 点击左边菜单按钮
    @objc func leftBtnClick() {
        DrawerViewController.shared?.showMenu()
    }
    
    // MARK:
    @objc private func rightBtnClick() {
        self.navigationController?.pushViewController(CitySelectorViewController(), animated: true)
    }
    
    // MARK: 收到通知后 更新UI
    @objc private func updateUI() {
        // 更新数据
        DispatchQueue.main.async {
            // 设置分页控制器的 总数(当只有一页时不显示)
            let count = dataArray?.count ?? 0
            if count > 1 {
                self.page.numberOfPages = (dataArray?.count)!
            } else if count == 1 {
                self.page.numberOfPages = 0
            } else {
                // 若没有数据
                DrawerViewController.shared?.hideMenu()
                let vc = CitySelectorViewController()
                vc.navigationItem.hidesBackButton = true
                self.navigationController?.pushViewController(vc, animated: false)
                return
            }
            self.collectionView.reloadData()
            let toast = SoolyToast(title: "成功更新数据！", duration: 2.5)
            toast.show(inView: self.view)
        }
    }
}

extension HomeViewController: GetWeatherDataDelegate {
    // MARK: 更新数据失败
    func getWeatherDataFailure() {
        DispatchQueue.main.async {
            let toast = SoolyToast(title: "更新数据失败，请检查网络连接！", duration: 2.5)
            toast.show(inView: self.view)
        }
    }
}

// MARK: UICollectionView 代理方法、数据源方法
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataArr = dataArray else {
            return 1
        }
        if dataArr.count == 0 {
            return 1
        }
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as!SWCollectionViewCell
        guard let dataArray = dataArray else {
            cell.weatherData = Weather()
            return cell
        }
        if dataArray.count == 0 {
            cell.weatherData = Weather()
            return cell
        }
        cell.weatherData = dataArray[indexPath.row]
        return cell
    }
    
    // MARK: 滑动时更新数据
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 更新page
            let pageNum = (Int(scrollView.contentOffset.x + scrollView.frame.width * 0.5) / Int(ScreenWidth)) % (dataArray?.count)!
            page.currentPage = pageNum
        
        // 当滑动到下一个item时 更新该item的数据
        let width = scrollView.frame.width
        switch scrollView.contentOffset.x {
        case width:
            GetWeatherData.weatherData(cityName: (dataArray?[1].city)!, isUpdateData: true)
        case width * 2:
            GetWeatherData.weatherData(cityName: (dataArray?[2].city)!, isUpdateData: true)
        case width * 3:
            GetWeatherData.weatherData(cityName: (dataArray?[3].city)!, isUpdateData: true)
        default:
            return
        }
    }
    
}
