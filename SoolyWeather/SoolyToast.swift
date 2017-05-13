//
//  SoolyToast.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/30.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  Toast提示

import UIKit

class SoolyToast: UIView {
    
    var textColor: UIColor
    var duration: TimeInterval
    var title: String
    var superView: UIView?
    
    /// 重载构造器
    ///
    /// - Parameters:
    ///   - title: toast - 消息
    ///   - textColor: 文字颜色
    ///   - duration: toast持续时间
    init(title: String, textColor: UIColor = UIColor.white, duration: Double) {
        
        // 1. 给属性赋值
        self.title = title
        self.textColor = textColor
        self.duration = duration
        
        // 2. 调用super.init() 必须调用父类的方法即 init(frame: CGRect)
        super.init(frame: CGRect(x: 2, y: 2, width: ScreenWidth - 2 * 2, height: 34))
        
        // 3. 初始化完成后 才能继续操作
        self.backgroundColor = mainColor
        self.addSubview(self.label)
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in view: UIView) {
        // 若存在Toast 则返回
        for view in view.subviews {
            if view is SoolyToast {
                return
            }
        }
        superView = view
        view.addSubview(self)
        view.bringSubview(toFront: self)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.9
        }
        
        UIView.animate(withDuration: 0.25, delay: duration, animations: {
            self.frame.origin.y -= 38
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    /// 标签
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = self.textColor
        label.text = self.title
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.center = self.center
        return label
    }()
}
