//
//  MapViewManager.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/11.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

protocol SetTabbarAndNavibarVisible {
    func setNaviBarVisable(makeVisible: Bool)
    func setTabbarVisable(makeVisible: Bool)
}

extension SetTabbarAndNavibarVisible where Self: UIViewController {
    
    func setNaviBarVisable(makeVisible: Bool) {
        guard let naviContro = self.navigationController else { return }
        
        let naviBarHight = naviContro.navigationBar.frame.height
        let statusHight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        
        let naviY: CGFloat = makeVisible ? statusHight : -naviBarHight
        UIView.animate(withDuration: 0.3) {
            naviContro.navigationBar.frame.origin.y = naviY
            return
        }
    }
    
    func setTabbarVisable(makeVisible: Bool) {
        guard let tabbarContro = self.tabBarController else { return }
        let tabbarHight = tabbarContro.tabBar.frame.height
        let viewY = self.view.frame.maxY
        
        let tabbarY: CGFloat = (makeVisible ? viewY-tabbarHight : viewY+tabbarHight)
        
        UIView.animate(withDuration: 0.3) {
            tabbarContro.tabBar.frame.origin.y = tabbarY
            return
        }
    }
    
    func checkNaviBarIsVisable() -> Bool {
        guard let naviContro = self.navigationController else { return false }
        return naviContro.navigationBar.frame.maxY > 0
    }
    
    func checkTabbarIsVisiable() -> Bool {
        guard let tabBarContro = self.tabBarController else { return false }
        return tabBarContro.tabBar.frame.origin.y < self.view.frame.maxY
    }
}

