//
//  ForecastCollectionViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/7.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    /// 星期
    @IBOutlet weak var weekLabel: UILabel!
    /// 天气图标
    @IBOutlet weak var iconView: UIImageView!
    /// 气温
    @IBOutlet weak var tempLabel: UILabel!
    /// 数据
    var forecastData: Forecast? {
        didSet {
            weekLabel.text = forecastData?.week ?? "无数据"
            let low = forecastData?.night?.templow ?? ""
            let high = forecastData?.day?.temphigh ?? ""
            tempLabel.text = "\(low)° - \(high)°"
            
            // FIXME: 只是传了白天的天气，需进行判断 时间 为 早间/晚间
            iconView.image = Weather.weatherIcon(weather: forecastData?.day?.weather ?? "", isBigPic: false)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        weekLabel.textColor = mainColor
        tempLabel.textColor = mainColor
    }

}
