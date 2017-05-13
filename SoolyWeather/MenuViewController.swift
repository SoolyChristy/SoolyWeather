//
//  MenuViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/15.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  抽屉菜单视图控制

import UIKit

private let myCityReuseID = "myCityReuseID"

class MenuViewController: UIViewController {

    /// 表格
    lazy var tableView: UITableView = {
       let tableView = UITableView(frame: CGRect(x: 0,
                                                 y: menuHeadViewHeight,
                                                 width: menuViewWidth,
                                                 height: ScreenHeight - menuHeadViewHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: WeatherDataNotificationName, object: nil)
    }
    

    /// 收到通知 更新UI
    @objc private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // 移除通知
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MenuViewController {
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
        // 创建头部视图
        setupHeaderView()
        
        // 注册nib
        tableView.register(UINib(nibName: "MyCitiesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: myCityReuseID)
        tableView.rowHeight = myCitiesCellHeight
        
        view.addSubview(tableView)
    }
    
    private func setupHeaderView() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: menuViewWidth, height: menuHeadViewHeight))
        headView.backgroundColor = mainColor
        view.addSubview(headView)
        
        let headLabel = UILabel()
        headLabel.text = "SoolyWeather"
        headLabel.textColor = UIColor.white
        headLabel.font = UIFont(name: "Adobe Clean", size: 45)
        headLabel.numberOfLines = 0
        headView.addSubview(headLabel)
        
        headLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.center.equalToSuperview()
            make.width.equalTo(menuViewWidth - 40)
        }
    }
}

// MARK: 表格的数据源方法、代理方法
extension MenuViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myCityReuseID, for: indexPath) as! MyCitiesTableViewCell
        cell.weatherData = dataArray?[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: menuViewWidth, height: myCityMargin))
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return myCityMargin
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: cell点击删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataArray?.remove(at: indexPath.section)
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
        // 删除完成后 发送通知
        NotificationCenter.default.post(name: deleteDataNotificationName, object: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}
