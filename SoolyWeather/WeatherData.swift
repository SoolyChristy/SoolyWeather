//
//  WeatherData.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 17/3/2.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import Foundation
import HandyJSON

class GetWeatherData {
    
    var weatherData: Weather = Weather()
    
    /// 创建单例
    static let shared = GetWeatherData()
    
    class func weatherData(cityName: String) {
        self.shared.getWeatherData(cityName: cityName)
    }
    
    private func getWeatherData(cityName: String) {
        let appCode = "647138002fd44f8abcaefe88afcfb71f"
        let host = "http://jisutianqi.market.alicloudapi.com"
        let path = "/weather/query"
        let querys = "?city=\(cityName)"
        let urlStr = host + path + querys
        /// 带中文的URL创建 必须将编码方式改为utf8 否则 URL为空
        let encodedUrl = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: encodedUrl)
        /// 创建请求
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy(rawValue: 1)!, timeoutInterval: 5)
        request.httpMethod = "GET"
        request.addValue("APPCODE \(appCode)", forHTTPHeaderField: "Authorization")
        let requestSession = URLSession(configuration: .default)
        /// 发起网络请求
        requestSession.dataTask(with: request, completionHandler: {(data,respose,error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            /// 利用SwifyJSON 解析JSON
            let json = JSON.init(data: data!)
            let dict = json["result"].dictionaryObject as? NSDictionary
            /// 利用HandyJSON 字典转模型
            self.weatherData = JSONDeserializer<Weather>.deserializeFrom(dict: dict)!
            print(self.weatherData)
            
            /// 数据请求完毕后 发送通知 并传递数据
            NotificationCenter.default.post(name: WeatherDataNotificationName, object: nil, userInfo: ["data": self.weatherData])
            
        }).resume()
    }
}
