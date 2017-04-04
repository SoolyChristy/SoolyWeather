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
        
        rootVC?.view.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        rootVC?.view.layer.shadowOffset = CGSize(width: -2, height: -1)
        rootVC?.view.layer.shadowOpacity = 0.7
        rootVC?.view.layer.shadowRadius = 2

        
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
        
        UIView.animate(withDuration: 0.25, animations: { 
//            self.menuVC?.view.transform = CGAffineTransform.identity
//            self.rootVC?.view.transform = CGAffineTransform(translationX: self.menuWidth, y: 0)
            self.rootVC?.view.frame.origin.x = self.menuWidth

        }) { (finishi: Bool) in

            // 加入蒙版
            SoolyCover.show(frame: (self.rootVC?.view.frame)!, type: .clear)
            self.addGesture()
        }
    }
    
    // MARK: 关闭菜单页
    func hideMenu() {
        UIView.animate(withDuration: 0.25, animations: { 
//            self.rootVC?.view.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.menuVC?.view.transform = CGAffineTransform.identity
            self.rootVC?.view.frame.origin.x = 0
            self.menuVC?.view.frame.origin.x = 0
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
}

extension DrawerViewController {
    // MARK: - 添加屏幕边缘手势
    func addScreenEdgePanGestureRecognizerToView(view: UIView) {
        
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeGes(pan:)))
        pan.edges = UIRectEdge.left
        view.addGestureRecognizer(pan)
    }
    
    // MARK: 菜单滑动后添加手势
    fileprivate func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(setupRootViewFrame(pan:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        SoolyCover.shared.addGestureRecognizer(panGesture)
        SoolyCover.shared.addGestureRecognizer(tapGesture)
    }
    
    // MARK: 点击手势
    @objc private func tap() {
        SoolyCover.hide()
        hideMenu()
    }
    
    // MARK: 菜单打开时滑动时rootView跟随手指移动
    @objc private func setupRootViewFrame(pan: UIPanGestureRecognizer) {
        let offsetX = pan.translation(in: pan.view).x
        
        if pan.state == UIGestureRecognizerState.changed {
            var originalX = menuWidth
            if offsetX < 0 {
                originalX += offsetX
                rootVC?.view.frame.origin.x = originalX
            }else {
                rootVC?.view.frame.origin.x = menuWidth
            }
            
        }else if pan.state == UIGestureRecognizerState.ended || pan.state == UIGestureRecognizerState.cancelled || pan.state == UIGestureRecognizerState.failed {
            // 隐藏蒙版
            SoolyCover.hide()
            if -offsetX > (ScreenWidth / 2 - ScreenWidth + menuWidth) {
                hideMenu()
            }else {
                showMenu()
            }
        }
    }
    
    // MARK: 边缘手势
    @objc fileprivate func edgeGes(pan: UIScreenEdgePanGestureRecognizer) {
        var offsetX = pan.translation(in: pan.view).x
        
        if offsetX > menuWidth {
            offsetX = menuWidth
        }
        if pan.state == UIGestureRecognizerState.changed {
            if offsetX > 0 {
                rootVC?.view.frame.origin.x = offsetX
            }
        }else if pan.state == UIGestureRecognizerState.ended || pan.state == UIGestureRecognizerState.cancelled || pan.state == UIGestureRecognizerState.failed {
            if offsetX > (ScreenWidth / 2) {
                showMenu()
            }else {
                hideMenu()
            }
        }
    }
}
