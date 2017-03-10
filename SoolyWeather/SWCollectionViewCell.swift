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
    lazy var pm2_5: UIButton = UIButton(imageName: "nice")
    /// 风速btn
    lazy var windSpeed: UIButton = UIButton(imageName: "windspeed")
    /// 湿度btn
    lazy var humidity: UIButton = UIButton(imageName: "shidu")
    /// 分割线
    @IBOutlet weak var separatorView: UIView!
    /// 数据
    var weatherData: Weather? {
        didSet {
            /// 给子视图赋值
            cityLabel.text = weatherData?.city ?? "无数据"
            weatherLabel.text = weatherData?.weather ?? "无数据"
            tempLabel.text = weatherData?.temp ?? "无数据"
            pm2_5.btnSetData(data: weatherData?.aqi?.quality ?? "无数据")
            windSpeed.btnSetData(data: weatherData?.windspeed ?? "无数据")
            humidity.btnSetData(data: weatherData?.humidity ?? "无数据")
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
        
        setupBtn()
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
        
        // 设置颜色
        cityLabel.textColor = mainColor
        tempLabel.textColor = mainColor
        weatherLabel.textColor = mainColor
    }

    // MARK: 创建三个指标btn
    private func setupBtn() {
        /// btn间距
        let margin: CGFloat = 1
        /// btn宽度
        let width: CGFloat = 108
        /// btn高度
        let height: CGFloat = 30
        /// 与边缘的间距
        let leftRightMargin = (ScreenWidth - 3 * width + 2 * margin) / 2
        /// btn y值
        let y: CGFloat = separatorView.frame.origin.y - 20
        
        windSpeed.frame = CGRect(x: leftRightMargin, y: y, width: width, height: height)
        pm2_5.frame = CGRect(x: leftRightMargin + margin + width, y: y, width: width, height: height)
        humidity.frame = CGRect(x: leftRightMargin + 2 * margin + 2 * width, y: y, width: width, height: height)
        
        self.addSubview(pm2_5)
        self.addSubview(windSpeed)
        self.addSubview(humidity)
        
    }
    
    }

// MARK: forecastCollectionView 数据源方法、代理方法
extension SWCollectionViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if weatherData != nil {
            return weatherData?.daily?.count ?? 7
        }else {
            return 7
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? ForecastCollectionViewCell
        if weatherData != nil {
            cell?.forecastData = weatherData?.daily?[indexPath.row] ?? Forecast()
        }
        return cell!
    }
}
