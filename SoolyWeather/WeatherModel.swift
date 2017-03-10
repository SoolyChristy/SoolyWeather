//
//  WeatherModel.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 17/3/1.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import Foundation
import HandyJSON

class Weather: HandyJSON {
    /// 城市
    var city: String?
    /// 日期
    var date: String?
    /// 星期
    var week: String?
    /// 天气
    var weather: String?
    /// 温度
    var temp: String?
    var temphigh: String?
    var templow: String?
    /// 湿度
    var humidity: String?
    /// 气压
    var pressure: String?
    /// 风速
    var windspeed: String?
    /// 风向
    var winddirect: String?
    /// 风力
    var windpower: String?
    /// 更新时间
    var updatetime: String?
    /// 指数
    var aqi: Aqi?
    /// 生活指数
    var index: [Any]?
    /// 未来天气预报
    var daily: [Forecast]?
    
    required init() {}
    
    
    /// 根据天气类型返回天气图标
    ///
    /// - Parameters:
    ///   - weather: 天气类型
    ///   - isBigPic: 是否是大图（若为ture则 返回大图）
    /// - Returns: 返回天气图标
    class func weatherIcon(weather: String, isBigPic: Bool) -> UIImage {
        
        var x = "s"
        if isBigPic {
            x = "b"
        }
        switch weather {
        case "晴":
            return UIImage(named: "sun_\(x)")!
        case "多云":
            return UIImage(named: "cloudy_\(x)")!
        case "阴":
            return UIImage(named: "yin_\(x)")!
        case "雾":
            return UIImage(named: "fog_\(x)")!
        case "小雨":
            return UIImage(named: "rain_\(x)_s")!
        case "中雨":
            return UIImage(named: "rain_\(x)_m")!
        case "大雨":
            return UIImage(named: "rain_\(x)_h")!
        case "暴雨":
            return UIImage(named: "rain_\(x)_hh")!
        case "小雪":
            return UIImage(named: "snow_\(x)_s")!
        case "中雪":
            return UIImage(named: "snow_\(x)_m")!
        case "大雪":
            return UIImage(named: "snow_\(x)_h")!
        case "暴雪":
            return UIImage(named: "sonw_\(x)_h")!
        case "阵雨":
            return UIImage(named: "zhenyu_\(x)")!
        case "雷阵雨":
            return UIImage(named: "leizhenyu_\(x)")!
        default:
            return UIImage(named: "cloudy_\(x)")!
        }
    }
    
}

class Aqi: HandyJSON {
    /// pm2.5
    var ipm2_5: String?
    /// 空气质量
    var quality: String?
    
    required init() {}
}

/// 未来天气预报
class Forecast: HandyJSON {
    var date: String?
    var week: String?
    var sunrise: String?
    var sunset: String?
    var day: Day?
    var night: Night?
    
    required init() {}
}

/// 白天
class Day: HandyJSON {
    var temphigh: String?
    var weather: String?
    
    required init() {}
}

/// 夜间
class Night: HandyJSON {
    var templow: String?
    var weather: String?
    
    required init() {}
}

