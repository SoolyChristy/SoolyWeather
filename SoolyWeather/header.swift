//
//  header.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/8.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import Foundation
import UIKit

let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height
let ScreenBounds: CGRect = UIScreen.main.bounds

/// 主配色
let mainColor = UIColor.color(hex: "#707070")

/// 主页指标btn Attributes
let btnAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName: mainColor]

/// 热门城市btn
let btnMargin: CGFloat = 15
let btnWidth: CGFloat = (ScreenWidth - 90) / 3
let btnHeight: CGFloat = 36

/// 通知
let WeatherDataNotificationName = Notification.Name(rawValue: "GetWeatherDataSuccessful")
