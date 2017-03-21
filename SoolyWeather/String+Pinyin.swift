//
//  String+Pinyin.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/14.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // MARK: 汉字 -> 拼音
    func chineseToPinyin(chinese: String) -> String {
        
        let stringRef = NSMutableString(string: self) as CFMutableString
        // 转换为带音标的拼音
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)
        let pinyin = stringRef as String
        
        return pinyin
    }
    
}
