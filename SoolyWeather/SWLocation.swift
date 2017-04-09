//
//  SWLocation.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/4/9.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  定位

import Foundation
import CoreLocation

class SWLocation: NSObject {
    /// 单例
    static let shared = SWLocation()
    
    var locationManager = CLLocationManager()
    /// 定位城市
    var city: String = ""
    /// 完成回调
    var compeletion: (_ city: String) -> () = {_ in }
    /// 失败回调
    var failure: () -> () = {}
    
    class func getCurrentCity(compeletion: @escaping (_ city: String) -> (), failure: @escaping () -> () = {}) {
        shared.compeletion = compeletion
        shared.failure = failure
        shared.setupManager()
    }
    
    private func setupManager() {
        // 请求权限
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        
        // 定位精度
        locationManager.desiredAccuracy = 10
        
        // 开始定位
        locationManager.startUpdatingLocation()
    }
    
    // MARK: 经纬度 => 城市
    fileprivate func locationToCity(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard let placeDic = placemark?.last?.addressDictionary else {
                print("定位转换失败")
                
                // 执行失败回调
                self.failure()
                
                return
            }
            print("定位详细信息 - \(placeDic)")
            
            // 获取城市
            let city = placeDic["City"] as? String ?? ""
            
            // 只发送一次通知
            if self.city == "" || self.city == city {
                
                self.city = city
                
                // 执行成功回调
                self.compeletion(city)
            }
        }
    }
}

// MARK: CoreLocation代理方法
extension SWLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("定位信息为空")
            return
        }
        print("经度 - \(location.coordinate.latitude)")
        print("纬度 - \(location.coordinate.longitude)")
        locationToCity(location: location)
        
        // 停止定位
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
    }
}
