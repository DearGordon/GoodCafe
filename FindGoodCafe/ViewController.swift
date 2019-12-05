//
//  ViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/5.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//
import UIKit

class ViewController: UIViewController,SetTabbarAndNavigationbar {
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        searchBar.placeholder = "請搜尋你要的咖啡店"
        self.navigationItem.titleView = searchBar
        
        
        let singleFinger = UITapGestureRecognizer(
        target:self,
        action:#selector(singleTap))
        self.view.addGestureRecognizer(singleFinger)
    }
    
    @objc func singleTap(){
        if searchBar.isFirstResponder{
            searchBar.endEditing(true)
            return
        }
        
        let check = checkTabbarIsVisiable()
        setTabbarVisable(visible: !check, animated: true)
    }
    
    
    @IBAction func hidTabbar(_ sender: Any) {
        let check = self.view.backgroundColor == UIColor.yellow
        self.view.backgroundColor = check ? UIColor.red : UIColor.yellow
    }
    
    
    
    
    
}

protocol SetTabbarAndNavigationbar {
    func setTabbarVisable(visible:Bool,animated:Bool)
    func checkTabbarIsVisiable()->Bool
}

extension SetTabbarAndNavigationbar where Self:UIViewController{
    
    func setTabbarVisable(visible:Bool,animated:Bool){
        guard let naviC = self.navigationController, let tabbarC = self.tabBarController else {return}
        
        let tabbarY:CGFloat = (visible ? -50.0 : 50.0)
        let navibarY:CGFloat = (visible ? 100 : -100)
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        UIView.animate(withDuration: duration) {
            naviC.navigationBar.frame = naviC.navigationBar.frame.offsetBy(dx: 0, dy: navibarY)
            tabbarC.tabBar.frame = tabbarC.tabBar.frame.offsetBy(dx: 0, dy: tabbarY)
            return
        }
    }
    
    func checkTabbarIsVisiable()->Bool{
        guard let tabBarController = tabBarController else {return false}
        return tabBarController.tabBar.frame.origin.y < self.view.frame.maxY
    }
}


