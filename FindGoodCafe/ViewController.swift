//
//  ViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/5.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//
import UIKit

class ViewController: UIViewController,SetTabbarAndNavibarVisible,ShowAlertable {

    
    
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
        setNaviBarVisable()
        setTabbarVisable()
    }
    
    
    @IBAction func hidTabbar(_ sender: Any) {
        
        showAlert(title: "你好", content: "內容", completion: nil)
    }
    
    
    
    
    
}

protocol ShowAlertable {
    
    func showAlert(title: String, content: String, actions: [UIAlertAction]?, preferredStyle: UIAlertController.Style, completion: (() -> ())?)
}

extension ShowAlertable where Self: UIViewController {
    
    func showAlert(title: String, content: String, actions: [UIAlertAction]? = nil, preferredStyle: UIAlertController.Style = .alert, completion: (() -> ())?) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: preferredStyle)
        if let actions = actions {
            actions.forEach({ alert.addAction($0) })
        }else{
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        }
        present(alert, animated: true, completion: completion)
    }
}




protocol SetTabbarAndNavibarVisible {
    func setNaviBarVisable()
    func setTabbarVisable()
}

extension SetTabbarAndNavibarVisible where Self:UIViewController{
    
    func setNaviBarVisable(){
        guard let naviContro = self.navigationController else { return }
        let makeVisible = !(checkNaviBarIsVisable())
        
        let naviY:CGFloat = makeVisible ? 100:-100
        UIView.animate(withDuration: 0.3) {
            naviContro.navigationBar.frame = naviContro.navigationBar.frame.offsetBy(dx: 0, dy: naviY)
            return
        }
    }
    
    func setTabbarVisable(){
        guard let tabbarC = self.tabBarController else { return }
        let makeVisible = !(checkTabbarIsVisiable())
        
        let tabbarY:CGFloat = (makeVisible ? -50.0 : 50.0)
        
        UIView.animate(withDuration: 0.3) {
            tabbarC.tabBar.frame = tabbarC.tabBar.frame.offsetBy(dx: 0, dy: tabbarY)
            return
        }
    }
    
    private func checkNaviBarIsVisable()->Bool{
        guard let naviContro = self.navigationController else { return false }
        return naviContro.navigationBar.frame.maxY > 0
    }
    
    private func checkTabbarIsVisiable()->Bool{
        guard let tabBarContro = self.tabBarController else { return false }
        return tabBarContro.tabBar.frame.origin.y < self.view.frame.maxY
    }
}


