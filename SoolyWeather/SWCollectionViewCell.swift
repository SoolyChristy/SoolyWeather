//
//  SWCollectionViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/5.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let reuseID = "ForecastCollectionViewCell"
class SWCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    /// 天气图标
    @IBOutlet weak var iconView: UIImageView!
    /// 城市名
    @IBOutlet weak var cityLabel: UILabel!
    /// 天气
    @IBOutlet weak var weatherLabel: UILabel!
    /// 温度
    @IBOutlet weak var tempLabel: UILabel!
    /// 空气质量btn
    @IBOutlet weak var pm2_5: UIButton!
    /// 风速btn
    @IBOutlet weak var windSpeed: UIButton!
    /// 更新时间
    @IBOutlet weak var upadateTime: UILabel!
    /// 湿度btn
    @IBOutlet weak var humidity: UIButton!
    /// 天气数据
    var weatherData: Weather? {
        didSet {
            /// 给子视图赋值
            cityLabel.text = weatherData?.city ?? "无数据"
            weatherLabel.text = weatherData?.weather ?? "无数据"
            tempLabel.text = weatherData?.temp ?? "无数据"
            upadateTime.text = (weatherData?.updatetime ?? "无数据") + " 发布"
            pm2_5.setTitle(weatherData?.aqi?.quality ?? "无数据", for: .normal)
            pm2_5.setImage(weatherData?.pm2_5Icon(index: weatherData?.aqi?.quality ?? "无数据"), for: .normal)
            windSpeed.setTitle(weatherData?.windpower ?? "无数据", for: .normal)
            humidity.setTitle(weatherData?.humidity ?? "无数据", for: .normal)
            iconView.image = Weather.weatherIcon(weather: weatherData?.weather ?? "", isBigPic: true)
            
            /// 子 collectionView 刷新数据
            forecastCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        /// 注册 xib
        forecastCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: reuseID)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
//        layout.sectionInset = UIEdgeInsetsMake(-0.1, -0.1, -0.1, -0.1)
        layout.itemSize = CGSize(width: ScreenWidth / 4, height: forecastCollectionView.bounds.height)
        layout.scrollDirection = .horizontal
        forecastCollectionView.collectionViewLayout = layout
        forecastCollectionView.dataSource = self
        forecastCollectionView.delegate = self
    }
    
    }

// MARK: forecastCollectionView 数据源方法、代理方法
extension SWCollectionViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard  let weatherData = weatherData else {
            return 7
        }
        return weatherData.daily?.count ?? 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! ForecastCollectionViewCell
        guard let weatherData = weatherData else {
            cell.forecastData = Forecast()
            return cell
        }
        cell.forecastData = weatherData.daily?[indexPath.row] ?? Forecast()
        return cell
    }
}
