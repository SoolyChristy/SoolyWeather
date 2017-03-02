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
    var index: [Any]?
//    var indexData: [Any]?
    
    required init() {}
}

class Aqi: HandyJSON {
    var ipm2_5: String?
    var quality: String?

    required init() {}
}


