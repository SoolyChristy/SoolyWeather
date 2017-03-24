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

    /// 表格
    lazy var tableView: UITableView = UITableView(frame: self.view.frame, style: .plain)
    /// 搜索控制器
    lazy var searchVC: UISearchController = {
       let searchVc = UISearchController(searchResultsController: self.searchResultVC)
        searchVc.searchResultsUpdater = self
        searchVc.hidesNavigationBarDuringPresentation = false
        /**
         * a、如果不添加下面这行代码，在设置hidesNavigationBarDuringPresentation这个属性为YES的时候，搜索框进入编辑模式会导致searchbar不可见，偏移-64; 在设置为NO的时候，进入编辑模式输入内容会导致高度为64的白条，猜测是导航栏没有渲染出来
           b、如果添加了下面这行代码，在设置hidesNavigationBarDuringPresentation这个属性为YES的时候，输入框进入编辑模式正常显示和使用; 在设置为NO的时候，搜索框进入编辑模式导致向下偏移64，具体原因暂时未找到
         */
        searchVc.definesPresentationContext = true
//        searchVc.dimsBackgroundDuringPresentation = false
        searchVc.searchBar.frame = CGRect(x: 0, y: 0, width: ScreenWidth - 114, height: 44)
        searchVc.searchBar.placeholder = "输入城市名或拼音查询"
        searchVc.searchBar.backgroundImage = UIColor.creatImageWithColor(color: UIColor.clear)
        searchVc.searchBar.delegate = self
        return searchVc
    }()
    /// 搜索结果控制器
    var searchResultVC: ResultTableViewController = ResultTableViewController()
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
        // 标题排序
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
        // 在导航条添加searchBar
        self.navigationItem.titleView = searchVC.searchBar
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

// MARK: UISearchResultsUpdating
extension CitySelectorViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchVC.searchBar.text != "" {
            searchResultVC.isFrameChange = true
        }
        getSearchResultArray(searchBarText: searchVC.searchBar.text ?? "")
    }
    
    private func getSearchResultArray(searchBarText: String) {
        var resultArray:[String] = []
        if searchBarText == "" {
            searchResultVC.resultArray = resultArray
            searchResultVC.tableView.reloadData()
            return
        }
        // 若文字为中文
        if searchBarText.isIncludeChineseIn() {
            // 转拼音
            let pinyin = searchBarText.chineseToPinyin()
            // 获取大写首字母
            let first = String(pinyin[pinyin.startIndex]).uppercased()
            guard let dic = cityDic[first] else {
                return
            }
            for str in dic {
                if str.hasPrefix(searchBarText) {
                    resultArray.append(str)
                }
            }
            searchResultVC.resultArray = resultArray
            searchResultVC.tableView.reloadData()
        }else {
        // 若文字是拼音
            // 若字符个数为1
            if searchBarText.characters.count == 1 {
                guard let dic = cityDic[searchBarText.uppercased()] else {
                    return
                }
                resultArray = dic
                searchResultVC.resultArray = resultArray
                searchResultVC.tableView.reloadData()
            }else {
                guard let dic = cityDic[searchBarText.first().uppercased()] else {
                    return
                }
                for str in dic {
                    // 去空格
                    let py = String(str.chineseToPinyin().characters.filter({ $0 != " "}))
                    let range = py.range(of: searchBarText)
                    if range != nil {
                        resultArray.append(str)
                    }
                }
                // 加入首字母判断 如 cq => 重庆 bj => 北京
                if resultArray.count == 0 {
                    for str in dic {
                        // 北京 => bei jing
                        let pinyin = str.chineseToPinyin()
                        // 获取空格的index
                        let a = pinyin.characters.index(of: " ")
                        let index = pinyin.index(a!, offsetBy: 2)
                        // offsetBy: 2 截取 bei j
                        // offsetBy: 1 截取 bei+空格
                        // substring(to: index) 不包含 index最后那个下标
                        let py = pinyin.substring(to: index)
                        /// 获取第二个首字母
                        ///
                        ///     py = "bei j"
                        ///     last = "j"
                        ///
                        let last = py.substring(from: py.index(py.endIndex, offsetBy: -1))
                        /// 两个首字母
                        let pyIndex = String(pinyin[pinyin.startIndex]) + last
                        
                        if searchBarText == pyIndex {
                            resultArray.append(str)
                        }
                    }
                }
                searchResultVC.resultArray = resultArray
                searchResultVC.tableView.reloadData()
            }
        }
    }
}

// MARK: searchBar 代理方法
extension CitySelectorViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        return true
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: recentCell, for: indexPath) as! RecentCitiesTableViewCell
            cell.callBack = { [weak self] (btn) in
                // 请求数据
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
            }
            return cell
        }else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: hotCityCell, for: indexPath) as! HotCityTableViewCell
            
            // 当点击热门城市按钮时调用此闭包
            cell.callBack = { [weak self] (btn) in
                // 请求数据
                GetWeatherData.weatherData(cityName: btn.titleLabel?.text ?? "")
                self?.navigationController?.pushViewController(HomeViewController(), animated: true)
            }
            return cell
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
            return btnHeight + 2 * btnMargin
        }else if indexPath.section == 1 {
            return btnHeight + 2 * btnMargin
        }else if indexPath.section == 2 {
            let row = (hotCities.count - 1) / 3
            return (btnHeight + 2 * btnMargin) + (btnMargin + btnHeight) * CGFloat(row)
        }else{
            return 42
        }
    }
}
