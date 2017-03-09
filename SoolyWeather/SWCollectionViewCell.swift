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
    lazy var windSpeed: UIButton = UIButton(imageName: "nice")
    /// 湿度btn
    lazy var humidity: UIButton = UIButton(imageName: "nice")
    /// 数据
    var weatherData: Weather? {
        didSet {
            cityLabel.text = weatherData?.city ?? "无数据"
            weatherLabel.text = weatherData?.weather ?? "无数据"
            tempLabel.text = weatherData?.temp ?? "无数据"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        
        setupBtn()
        self.backgroundColor = UIColor.white
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

    // MARK: 创建三个指标btn
    private func setupBtn() {
        /// btn间距
        let margin: CGFloat = 1
        /// btn宽度
        let width: CGFloat = 95
        /// btn高度
        let height: CGFloat = 30
        /// 与边缘的间距
        let leftRightMargin = (ScreenWidth - 3 * width + 2 * margin) / 2
        /// btn y值
        let y: CGFloat = forecastCollectionView.frame.minY - 20
        
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
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
//        cell.backgroundColor = UIColor.blue
        return cell
    }
}
