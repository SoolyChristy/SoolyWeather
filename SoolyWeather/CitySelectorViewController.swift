//
//  CitySelectorViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/9.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let nomalCell = "nomalCell"
private let hotCityCell = "hotCityCell"
private let recentCell = "rencentCityCell"
private let currentCell = "currentCityCell"

class CitySelectorViewController: UIViewController {

    lazy var tableView: UITableView = UITableView(frame: self.view.frame, style: .plain)
    /// 懒加载 城市数据
    lazy var cityDic: [String: [String]] = { () -> [String : [String]] in
        let path = Bundle.main.path(forResource: "cities.plist", ofType: nil)
        let dic = NSDictionary(contentsOfFile: path ?? "") as? [String: [String]]
        return dic ?? [:]
        }()
    /// 懒加载 热门城市
    lazy var hotCities: [String] = {
        let path = Bundle.main.path(forResource: "hotCities.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path ?? "") as? [String]
        return array ?? []
    }()
    /// 懒加载 标题数组
    lazy var titleArray: [String] = { () -> [String] in
       var array = [String]()
        for str in self.cityDic.keys {
            array.append(str)
        }
        /// 标题排序
        array.sort()
        array.insert("热门", at: 0)
        array.insert("最近", at: 0)
        array.insert("当前", at: 0)
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(self.titleArray)
    }

    private func setupUI() {
        self.title = "选择城市"
        self.navigationController?.navigationBar.titleTextAttributes = {[
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18)
            ]}()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: nomalCell)
        tableView.register(RecentCitiesTableViewCell.self, forCellReuseIdentifier: recentCell)
        tableView.register(CurrentCityTableViewCell.self, forCellReuseIdentifier: currentCell)
        tableView.register(HotCityTableViewCell.self, forCellReuseIdentifier: hotCityCell)
        // 右边索引
        tableView.sectionIndexColor = mainColor
//        tableView.sectionIndexTrackingBackgroundColor = UIColor.white
        tableView.sectionIndexBackgroundColor = UIColor.clear
        self.view.addSubview(tableView)

    }
    
    deinit {
        print("我走了")
    }

}

// MARK: tableView 代理方法、数据源方法
extension CitySelectorViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section > 2 {
            let key = titleArray[section]
            return cityDic[key]!.count - 3
        }
        return 1
    }
    
    // MARK: 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: currentCell, for: indexPath)
            cell.backgroundColor = cellColor
            return cell
            
        }else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: recentCell, for: indexPath)
            cell.backgroundColor = cellColor
            return cell
        }else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as? HotCityTableViewCell
            
            /// 当点击热门城市按钮时调用此闭包
            cell?.callBack = { [weak self] (btn) in
                /// 请求数据
                GetWeatherData.weatherData(cityName: btn.titleLabel?.text ?? "")
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
            }
            return cell!
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nomalCell, for: indexPath)
//            cell.backgroundColor = cellColor
            let key = titleArray[indexPath.section]
            cell.textLabel?.text = cityDic[key]![indexPath.row]
            return cell
        }
        
    }
    // MARK: 点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        print("点击了 \(cell?.textLabel?.text ?? "")")
        if indexPath.section > 2 {
            /// 请求数据
            GetWeatherData.weatherData(cityName: cell?.textLabel?.text ?? "")
            self.navigationController?.pushViewController(HomeViewController(), animated: true)
        }else {
            return
        }
    }
    
    // MARK: 右边索引
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titleArray
    }
    
    // MARK: section头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: sectionMargin))
        let title = UILabel(frame: CGRect(x: 15, y: 5, width: ScreenWidth - 15, height: 28))
        var titleArr = titleArray
        titleArr[0] = "当前城市"
        titleArr[1] = "最近选择城市"
        titleArr[2] = "热门城市"
        title.text = titleArr[section]
        title.textColor = mainColor
        title.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(title)
        view.backgroundColor = UIColor.white
        if section > 2 {
            view.backgroundColor = mainColor
            title.textColor = UIColor.white
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionMargin
    }
    
    // MARK: row高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 42
        }else if indexPath.section == 1 {
            return 42
        }else if indexPath.section == 2 {
            let row = (hotCities.count - 1) / 3
            return (btnHeight + 2 * btnMargin) + (btnMargin + btnHeight) * CGFloat(row)
        }else{
            return 42
        }
    }
}
