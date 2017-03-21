//
//  MenuViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/15.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

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
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        // 创建头部视图
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
        tableView.register(UINib(nibName: "MyCitiesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: myCityReuseID)
        tableView.rowHeight = myCitiesCellHeight
        view.addSubview(tableView)
        
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
        view.backgroundColor = cellColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return myCityMargin
    }
}
