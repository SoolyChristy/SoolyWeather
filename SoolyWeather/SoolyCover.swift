//
//  SoolyCover.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/14.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class SoolyCover: UIView {
    
    static let shared = SoolyCover()
    
    var callBack: () -> () = {}
    
    enum background {
        case clear
        case gray
    }
    
    
    /// 显示蒙版
    ///
    /// - type: 蒙版类型 -（透明、灰色）（默认为透明）
    /// - clickCallBack: - 点击蒙版回调（默认为空）
    class func show(frame: CGRect, type: background = .gray, clickCallBack: @escaping () -> () = {} ) {
        
        shared.frame = frame
        switch type {
        case .clear:
            shared.backgroundColor = UIColor.clear
        case .gray:
            shared.backgroundColor = UIColor.black
            shared.alpha = 0.5
        }
        shared.callBack = clickCallBack
        UIApplication.shared.delegate?.window??.addSubview(shared)
    }
    
    // MARK: 点击蒙版调用
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.removeFromSuperview()
        callBack()
    }
    
}
