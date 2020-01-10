//
//  MapViewController+Extention.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2020/1/10.
//  Copyright © 2020 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

extension MapViewController: UISearchControllerDelegate {
    
    func setMyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "clearBtn"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(clear(sender:)), for: .touchUpInside)
        searchTF.rightView = clearButton
        searchTF.rightViewMode = .always
    }
    
    @objc func clear(sender : AnyObject) {
        if searchTF.text == "" { return }
        isPicking = false
        setFootViewVisable(makeVisible: false)
        setTabbarVisable(makeVisible: true)
        searchTF.text = ""
    }
    
    func addSearchTFInNaviBar() {
        guard let naviCtrl = self.navigationController else { return }
        naviCtrl.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        naviCtrl.navigationBar.shadowImage = UIImage()
        naviCtrl.navigationBar.isTranslucent = true
        naviCtrl.view.backgroundColor = UIColor.clear
        
        if let vc = storyboard?.instantiateViewController(identifier: "result") as? SearchResultVC {
            vc.data = self.pinsArray
            searchCtrl = UISearchController(searchResultsController: vc)
            searchCtrl.searchResultsUpdater = vc
            searchCtrl.delegate = self
            
            self.navigationItem.searchController = searchCtrl
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if searchCtrl.searchBar.text == "" {
            isPicking = false
            setMapStatuse(statuse: .standard)
        }
    }
}






extension MapViewController {
    
    func setNaviBarVisable(makeVisible: Bool) {
        guard let naviContro = self.navigationController else { return }
        
        let naviBarHight = naviContro.navigationBar.frame.height
        let statusHight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        
        let naviY: CGFloat = makeVisible ? statusHight : -naviBarHight
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .showHideTransitionViews, animations: {
            naviContro.navigationBar.frame.origin.y = naviY
        }, completion: nil)
        
    }
    
    func setTabbarVisable(makeVisible: Bool) {
        guard let tabbarContro = self.tabBarController else { return }
        let tabbarHight = tabbarContro.tabBar.frame.height
        let viewY = self.view.frame.maxY
        
        let tabbarY: CGFloat = (makeVisible ? viewY-tabbarHight : viewY+tabbarHight)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .showHideTransitionViews, animations: {
            tabbarContro.tabBar.frame.origin.y = tabbarY
        }, completion: nil)
    }
    
    func setFootViewVisable(makeVisible: Bool) {
        let viewMaxY = self.view.frame.maxY
        
        self.view.bringSubviewToFront(footView)
        
        footViewConstraY.constant = makeVisible ? (viewMaxY - addressLB.frame.maxY) : viewMaxY
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .showHideTransitionViews, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func checkFootViewVisable() -> Bool {
        guard let footView = self.footView else { return false }
        return footView.frame.minY < self.view.frame.maxY
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
