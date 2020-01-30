//
//  MapViewController+Extention.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2020/1/10.
//  Copyright © 2020 Kuan-Chieh Feng. All rights reserved.
//

import UIKit
import MapKit

extension MapViewController: TransferShope {
    
    func transferShope(shope: CoffeeShop) {
        mapViewModel.selectShope = shope
    }
    
}

extension MapViewController: UISearchControllerDelegate {
    
    func addSearchBarInNaviBar() {
        guard let naviCtrl = self.navigationController else { return }
        naviCtrl.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        naviCtrl.navigationBar.shadowImage = UIImage()
        naviCtrl.navigationBar.isTranslucent = true
        naviCtrl.view.backgroundColor = UIColor.clear
        
        if let vc = storyboard?.instantiateViewController(identifier: "result") as? SearchResultVC {
            vc.delegate = self
            vc.data = mapViewModel.pinsArray
            searchCtrl = UISearchController(searchResultsController: vc)
            searchCtrl.searchResultsUpdater = vc
            searchCtrl.delegate = self
            
            self.navigationItem.searchController = searchCtrl
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if searchCtrl.searchBar.text == "" {
            isPicking = false
            setMapStatuse(statuse: .Standard)
        }
    }
}

//MARK: Gesture Thing
extension MapViewController {
    
    func addGRInFootView() {
        let singleFinger = UITapGestureRecognizer(target: self,action: #selector(singleTap))
        self.view.addGestureRecognizer(singleFinger)
        
        for direction in [
            UISwipeGestureRecognizer.Direction.up,
            UISwipeGestureRecognizer.Direction.down]
        {
            let gr = UISwipeGestureRecognizer(target: self, action: #selector(swipeFootViewDetail))
            gr.direction = direction
            footView.addGestureRecognizer(gr)
        }
    }
    
    @objc func swipeFootViewDetail(gr:UISwipeGestureRecognizer) {
        let direction = gr.direction
        let viewMaxY = self.view.frame.maxY
        switch direction {
        case UISwipeGestureRecognizer.Direction.up:
            footViewConstraY.constant = viewMaxY - footView.frame.height
        case UISwipeGestureRecognizer.Direction.down:
            footViewConstraY.constant = viewMaxY - footView.seatLB.frame.minY
        default:
            print("not going this way")
        }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 0, options: .allowUserInteraction, animations: {
            self.footView.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func singleTap() {
        setNaviBarVisable(makeVisible: !checkNaviBarIsVisable())
        var status :MapStatuse = .Standard
        switch isPicking {
        case true:
            status = checkNaviBarIsVisable() ? .SelectShope : .ClearMap
        case false:
            status = checkNaviBarIsVisable() ? .Standard    : .ClearMap
        }
        setMapStatuse(statuse: status)
    }
    
}

//MARK:Set Navi/TabBar/FootView
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
        
        
        footViewConstraY.constant = makeVisible ? (viewMaxY - footView.seatLB.frame.minY) : viewMaxY
        
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
