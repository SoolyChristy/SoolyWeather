//
//  CurrentCityTableViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/10.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  当前城市cell

import UIKit

class CurrentCityTableViewCell: UITableViewCell {

    /// 回调
    var callBack: (() -> ())?
    /// 当前城市
    var currentCity: String? {
        didSet{
            if let city = currentCity {
                currentCityBtn.setTitle(city, for: .normal)
                currentCityBtn.isHidden = false
            }
        }
    }
    /// 当前城市btn
    var currentCityBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: btnMargin, y: btnMargin, width: btnWidth, height: btnHeight))
        btn.setTitleColor(mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.white
        //            btn.layer.borderColor = mainColor.cgColor
        //            btn.layer.borderWidth = 0.5
        btn.layer.cornerRadius = 1
        btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
        btn.isHidden = true
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = cellColor
        addSubview(currentCityBtn)
        currentCityBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
    }
    
    @objc private func btnClick(btn: UIButton) {
        NetworkManager.weatherData(cityName: btn.titleLabel?.text ?? "")
        callBack!()
    }
}
