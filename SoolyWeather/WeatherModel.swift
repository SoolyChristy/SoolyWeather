//
//  WeatherModel.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 17/3/1.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import Foundation

//"result": {
//    "city": "安顺",
//    "cityid": "111",
//    "citycode": "101260301",
//    "date": "2015-12-22",
//    "week": "星期二",
//    "weather": "多云",
//    "temp": "16",
//    "temphigh": "18",
//    "templow": "9",
//    "img": "1",
//    "humidity": "55",
//    "pressure": "879",
//    "windspeed": "14.0",
//    "winddirect": "南风",
//    "windpower": "2级",
//    "updatetime": "2015-12-22 15:37:03",
//    "index": [
//    {
//    "iname": "空调指数",
//    "ivalue": "较少开启",
//    "detail": "您将感到很舒适，一般不需要开启空调。"
//    },
//    {
//    "iname": "运动指数",
//    "ivalue": "较适宜",
//    "detail": "天气较好，无雨水困扰，较适宜进行各种运动，但因气温较低，在户外运动请注意增减衣物。"
//    }
//    ],
//    "aqi": {
//        "so2": "37",
//        "so224": "43",
//        "no2": "24",
//        "no224": "21",
//        "co": "0.647",
//        "co24": "0.675",
//        "o3": "26",
//        "o38": "14",
//        "o324": "30",
//        "pm10": "30",
//        "pm1024": "35",
//        "pm2_5": "23",
//        "pm2_524": "24",
//        "iso2": "13",
//        "ino2": "13",
//        "ico": "7",
//        "io3": "9",
//        "io38": "7",
//        "ipm10": "35",
//        "ipm2_5": "35",
//        "aqi": "35",
//        "primarypollutant": "PM10",
//        "quality": "优",
//        "timepoint": "2015-12-09 16:00:00",
//        "aqiinfo": {
//            "level": "一级",
//            "color": "#00e400",
//            "affect": "空气质量令人满意，基本无空气污染",
//            "measure": "各类人群可正常活动"
//        }
//    },
//    "daily": [
//    {
//    "date": "2015-12-22",
//    "week": "星期二",
//    "sunrise": "07:39",
//    "sunset": "18:09",
//    "night": {
//    "weather": "多云",
//    "templow": "9",
//    "img": "1",
//    "winddirect": "无持续风向",
//    "windpower": "微风"
//    },
//    "day": {
//    "weather": "多云",
//    "temphigh": "18",
//    "img": "1",
//    "winddirect": "无持续风向",
//    "windpower": "微风"
//    }
//    }
//    ],
//    "hourly": [
//    {
//    "time": "16:00",
//    "weather": "多云",
//    "temp": "14",
//    "img": "1"
//    },
//    {
//    "time": "17:00",
//    "weather": "多云",
//    "temp": "13",
//    "img": "1"
//    }
//    ]
//}
//}

class Weather: NSObject{
    var city: String?
    var date: String?
    var week: String?
    var weather: String?
    var temp: String?
    var temphigh: String?
    var templow: String?
    var humidity: String?
    var pressure: String?
    var windspeed: String?
    var winddirect: String?
    var windpower: String?
    var updatetime: String?
    var aqi: Aqi?
    var indexData: [Any]?
    
    override var description: String{
        return yy_modelDescription()
    }
}

class Aqi: NSObject{
    var ipm2_5: String?
    var quality: String?

    override var description: String{
        return yy_modelDescription()
    }
}


