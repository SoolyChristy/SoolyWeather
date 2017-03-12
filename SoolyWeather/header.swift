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

/// document路径
let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
/// 天气数据路径
let dataArrPath = documentPath + "/dataArray.data"

/// 全局天气数据
var dataArray: [Weather]? = NSKeyedUnarchiver.unarchiveObject(withFile: dataArrPath) as? [Weather] ?? []

/// 主配色
let mainColor = UIColor.color(hex: "#707070")
/// cell背景色
let cellColor = UIColor.color(hex: "#EAEAEA")
/// btn 高亮背景色
let btnHighlightColor = UIColor.color(hex: "#efeff4")
/// btn 高亮图片
let btnHighlightImage = UIColor.creatImageWithColor(color: btnHighlightColor)

/// 主页指标btn Attributes
let btnAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName: mainColor]

/// section间距
let sectionMargin: CGFloat = 38

/// 热门城市btn
let btnMargin: CGFloat = 15
let btnWidth: CGFloat = (ScreenWidth - 90) / 3
let btnHeight: CGFloat = 36

/// 通知
let WeatherDataNotificationName = Notification.Name(rawValue: "GetWeatherDataSuccessful")
