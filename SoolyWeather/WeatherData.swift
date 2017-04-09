//
//  WeatherData.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 17/3/2.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  请求数据

import Foundation
import HandyJSON

class GetWeatherData {
    
    private let appCode = "647138002fd44f8abcaefe88afcfb71f"
    private let host = "http://jisutianqi.market.alicloudapi.com"
    private let path = "/weather/query"
    
    /// 创建单例
    static let shared = GetWeatherData()
    
    /// 代理
    weak var delegate: GetWeatherDataDelegate?
    
    /// 给外界提供 请求'天气数据'方法
    ///
    /// - Parameters:
    ///   - cityName: 城市名
    ///   - isUpdateData: 是否是首页更新数据（默认不是）
    class func weatherData(cityName: String, isUpdateData: Bool = false) {
        self.shared.getWeatherData(cityName: cityName, isUpdateData: isUpdateData)
    }
    
    private func getWeatherData(cityName: String, isUpdateData: Bool = false) {

        let querys = "?city=\(cityName)"
        let urlStr = host + path + querys
        
        // 带中文的URL创建 必须将编码方式改为utf8 否则 URL为空
        let encodedUrl = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: encodedUrl)
        
        // 创建请求
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy(rawValue: 1)!, timeoutInterval: 5)
        request.httpMethod = "GET"
        request.addValue("APPCODE \(appCode)", forHTTPHeaderField: "Authorization")
        let requestSession = URLSession(configuration: .default)
        
        // 发起网络请求
        requestSession.dataTask(with: request, completionHandler: {(data,respose,error) in
            if error != nil{
                print("请求数据失败 - \(error!)")
                
                // 请求失败调用代理方法
                self.delegate?.getWeatherDataFailure()
                
                return
            }
            // 利用SwifyJSON 解析JSON
            let json = JSON.init(data: data!)
            let dict = json["result"].dictionaryObject as NSDictionary?
            
            // 利用HandyJSON 字典转模型
            let weatherData = Weather.deserialize(from: dict) ?? Weather()
//            self.weatherData = JSONDeserializer<Weather>.deserializeFrom(dict: dict) ?? Weather()
            print("天气数据请求完毕,请求城市 " + (weatherData.city ?? "nil"))

            // 全局数据数组增加数据
            self.dataArrayaddData(data: weatherData, isUpdateData: isUpdateData)
            print(weatherData)
            // 数据请求完毕后 发送通知
            NotificationCenter.default.post(name: WeatherDataNotificationName, object: nil, userInfo: nil)
            
        }).resume()
    }
    
    // MARK: 全局数据数组增加数据
    private func dataArrayaddData(data: Weather, isUpdateData: Bool = false) {
        
        guard var dataArr = dataArray else {
            // 若 dataArray为空 则初始化数组 并添加数据
            dataArray = []
            dataArray?.append(data)
            return
        }
        if isUpdateData == true {
            // 若是更新首页数据 且 数据数组存在同名城市数据 则 替换该数据
            for i in 0..<dataArr.count {
                if data.city == dataArr[i].city {
                    dataArr[i] = data
                    dataArray = dataArr
                    return
                }
            }
        }else {
            // 若不是更新首页数据 且 数据存在同名城市数据 则 删除该数据 将新数据插入0号位置
            for i in 0..<dataArr.count {
                if data.city == dataArr[i].city {
                    dataArr.remove(at: i)
                    dataArr.insert(data, at: 0)
                    dataArray = dataArr
                    return
                }
            }
            // 若数据量超过规定大小则删除末尾数据 插入新数据
            if dataArr.count == 4 {
                dataArr.removeLast()
            }
            dataArr.insert(data, at: 0)
        }
        dataArray = dataArr
    }
}

protocol GetWeatherDataDelegate: NSObjectProtocol {
    func getWeatherDataFailure()
}
