//
//  DrawerViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/15.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//  抽屉视图控制器

import UIKit

class DrawerViewController: UIViewController {

    /// 主页
    var rootVC: UIViewController?
    /// 左侧菜单
    var menuVC: UIViewController?
    /// 菜单宽度
    var menuWidth: CGFloat = menuViewWidth
    /// 抽屉视图控制器单例
    static let shared = UIApplication.shared.keyWindow?.rootViewController as? DrawerViewController
    
    init(rootViewController: UIViewController, menuViewController: UIViewController) {
        
        super.init(nibName: nil, bundle: nil)
        
        rootVC = rootViewController
        menuVC = menuViewController
        
        view.addSubview(menuViewController.view)
        view.addSubview(rootViewController.view)

        
        addChildViewController(menuViewController)
        addChildViewController(rootViewController)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        menuVC?.view.transform = CGAffineTransform(translationX: -menuViewWidth, y: 0)
        
        for childViewController in (rootVC?.childViewControllers)! {
            
            for subview in childViewController.view.subviews {
                addScreenEdgePanGestureRecognizerToView(view: subview)
            }
            
        }
        
    }
    
    // MARK: 展开菜单页
    func showMenu() {
        let grayView = UIView(frame: (self.rootVC?.view.bounds)!)
        grayView.backgroundColor = UIColor.clear
        self.rootVC?.view.addSubview(grayView)
        UIView.animate(withDuration: 0.25, animations: { 
            self.menuVC?.view.transform = CGAffineTransform.identity
            self.rootVC?.view.transform = CGAffineTransform(translationX: self.menuWidth, y: 0)
            grayView.backgroundColor = UIColor.black
            grayView.alpha = 0.5
        }) { (finishi: Bool) in
            
            grayView.removeFromSuperview()
            // 加入蒙版
            SoolyCover.show(frame: CGRect(x: self.menuWidth, y: 0, width: ScreenWidth - self.menuWidth, height: ScreenHeight), type: .gray, clickCallBack: {
                self.hideMenu()
            })
        }
    }
    
    // MARK: 关闭菜单页
    func hideMenu() {
        UIView.animate(withDuration: 0.25, animations: { 
            self.rootVC?.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.menuVC?.view.transform = CGAffineTransform.identity
        }) { (finish: Bool) in
            // 回弹效果
            let positon = (self.rootVC?.view.layer.position)!
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = positon
            animation.toValue = CGPoint(x: positon.x + 8, y: positon.y)
            animation.duration = 0.15
            // 执行 逆行动画
            animation.autoreverses = true
            self.rootVC?.view.layer.add(animation, forKey: nil)
        }
    }
    
    // MARK: - 添加屏幕边缘手势
    func addScreenEdgePanGestureRecognizerToView(view: UIView) {
        
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgPanGesture(_:)))
        pan.edges = UIRectEdge.left
        view.addGestureRecognizer(pan)
        
    }
    
    // MARK: - 屏幕左边缘手势
    @objc private func edgPanGesture(_ pan: UIScreenEdgePanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        
        // view跟着手指移动
        if pan.state == UIGestureRecognizerState.changed && offsetX <= menuViewWidth {
            rootVC?.view.transform = CGAffineTransform(translationX: max(offsetX, 0), y: 0)
            menuVC?.view.transform = CGAffineTransform(translationX: -menuViewWidth + offsetX, y: 0)
        } else if pan.state == UIGestureRecognizerState.ended || pan.state == UIGestureRecognizerState.cancelled || pan.state == UIGestureRecognizerState.failed {
            
            if offsetX > ScreenWidth * 0.5 {
                showMenu()
                
            } else {
                hideMenu()
            }
            
        }
    }

}
