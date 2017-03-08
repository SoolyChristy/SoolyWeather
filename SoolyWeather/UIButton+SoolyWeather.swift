//
//  UIButton+SoolyWeather.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/8.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

let btnAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17),NSForegroundColorAttributeName: mainColor]

extension UIButton {
    // MARK: 便利构造函数快速创建btn
    convenience init(imageName: String, title: String = "无数据", color: UIColor = mainColor) {
        self.init()
        
        let att = NSAttributedString(string: title, attributes: btnAttributes)
        setTitle(title, for: .normal)
        setAttributedTitle(att, for: .normal)
        setTitleColor(color, for: .normal)
        setImage(UIImage(named: imageName), for: UIControlState.normal)

    }
    
    func setBtnTitle(title: String) {
        
    }
}
