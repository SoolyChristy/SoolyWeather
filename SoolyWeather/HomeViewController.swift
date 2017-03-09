//
//  HomeViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/5.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let reuseID = "SWCollectionViewCell"

class HomeViewController: UIViewController {

    var weatherData: Weather?
    
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
        setupUI()
        
    }
    
    private func setupUI() {
        self.title = "SoolyWeather"
        self.navigationController?.navigationBar.titleTextAttributes = {[
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "AdobeClean-Light", size: 18.0)!
            ]}()
        /// 创建左边item
        let leftBtn = UIButton(type: .custom)
        leftBtn.setTitle("城市", for: .normal)
        leftBtn.sizeToFit()
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        self.view.addSubview(self.collectionView)
        /// 注册cell
        collectionView.register(UINib(nibName: "SWCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseID)
        /// 接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(updataUI(notification:)), name: WeatherDataNotificationName, object: nil)
    }
    
    @objc private func leftBtnClick() {
        self.navigationController?.pushViewController(CitySelectorViewController(), animated: true)
    }
    
    // MARK: 收到数据后 更新UI
    @objc private func updataUI(notification: Notification) {
        weatherData = notification.userInfo?["data"] as? Weather
        /// 更新数据
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: UICollectionView 代理方法、数据源方法
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? SWCollectionViewCell
        cell?.weatherData = self.weatherData
        return cell!
    }
}
