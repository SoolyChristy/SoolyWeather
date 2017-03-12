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
            self.weatherData = Weather.deserialize(from: dict) ?? Weather()
//            self.weatherData = JSONDeserializer<Weather>.deserializeFrom(dict: dict) ?? Weather()
            print("天气数据请求完毕,请求城市 " + (self.weatherData.city ?? "nil"))
            
            /// 全局数据数组增加数据
            self.dataArrayaddData(data: self.weatherData)
            /// 数据请求完毕后 发送通知
            NotificationCenter.default.post(name: WeatherDataNotificationName, object: nil, userInfo: nil)
            
        }).resume()
    }
    
    // MARK: 全局数据数组增加数据
    private func dataArrayaddData(data: Weather) {
        // 判断数组里是否存在同名城市数据，若存在则 删除旧数据 -> 插入新数据 (最多4组数据)
        let count = dataArray?.count
        if count != 0 {
            for i in 0..<count! {
                if data.city == dataArray?[i].city {
                    dataArray?.remove(at: i)
                    dataArray?.insert(data, at: 0)
                    return
                }
            }
            if count == 4 {
                dataArray?.remove(at: 3)
                dataArray?.insert(data, at: 0)
                return
            }
        }
        dataArray?.insert(data, at: 0)
    }
}
