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
var dataArray: [Weather]? = NSKeyedUnarchiver.unarchiveObject(withFile: dataArrPath) as? [Weather]

/// 主配色
let mainColor = UIColor.color(hex: "#707070")
/// 浅灰 cell背景色
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

/// 菜单栏宽度
let menuViewWidth = ScreenWidth - 75
/// 菜单头部视图高度
let menuHeadViewHeight: CGFloat = 160
/// 菜单栏我的城市cell高度
let myCitiesCellHeight: CGFloat = 95
/// 我的城市间距
let myCityMargin: CGFloat = 10

/// 请求数据完成通知
let WeatherDataNotificationName = Notification.Name(rawValue: "GetWeatherDataSuccessfuly")
/// 删除数据完成通知
let deleteDataNotificationName = NSNotification.Name(rawValue: "DeleteDataSuccessfuly")
