//
//  RecentCityTableViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/10.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class RecentCitiesTableViewCell: UITableViewCell {

    /// 点击按钮执行该闭包 (可选)
    var callBack: ((_ btn: UIButton) -> ())?
    
    /// 使用tableView.dequeueReusableCell会自动调用这个方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = cellColor
        guard let dataCount = dataArray?.count else {
            return
        }
        var count = 3
        if dataCount < 4 {
            count = dataCount
        }
        for i in 0..<count {
            let x = btnMargin + CGFloat(i) * (btnMargin + btnWidth)
            let btn = UIButton(frame: CGRect(x: x, y: btnMargin, width: btnWidth, height: btnHeight))
            btn.setTitle(dataArray?[i].city, for: .normal)
            btn.setTitleColor(mainColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.backgroundColor = UIColor.white
            //            btn.layer.borderColor = mainColor.cgColor
            //            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)

        }
    }
    
    @objc private func btnClick(btn: UIButton) {
        // 执行闭包
        callBack!(btn)
        
    }



}
