//
//  MainViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/7.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /// 导航条不透明
        /// 若此属性为false则 在self.view增加的子视图frame y值为64 即子视图height应等于 ScreenHeight - 64
        /// 若为true frame的y值为0 bounds的y值为-64 子视图height不需要减64
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = mainColor
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = ["NSForegroundColorAttributeName": UIColor.white]
        self.navigationBar.titleTextAttributes = {[
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Heiti SC", size: 24.0)!
            ]}()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
