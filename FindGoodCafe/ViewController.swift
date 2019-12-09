//
//  ViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/5.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//
import UIKit

class ViewController: UIViewController,SetTabbarAndNavibarVisible,ShowAlertable {

    let searchTF = UITextField()
    var isPicking:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchTFInNaviBar()
        addSingleTap()
        
    }
    
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
        guard let naviContro = self.navigationController else { return }
        naviContro.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        naviContro.navigationBar.shadowImage = UIImage()
        naviContro.navigationBar.isTranslucent = true
        naviContro.view.backgroundColor = UIColor.clear
        
        searchTF.placeholder = "請搜尋你要的地點"
        searchTF.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*2/3, height: 30)
        setMyClearButton()
        
        self.navigationItem.titleView = searchTF
    }
    
    
    
    func addSingleTap() {
        let singleFinger = UITapGestureRecognizer(
        target:self,
        action:#selector(singleTap))
        self.view.addGestureRecognizer(singleFinger)
    }
    
    @objc func singleTap() {
        if searchTF.isFirstResponder {
            searchTF.endEditing(true)
            return
        }
        setNaviBarVisable(makeVisible: !checkNaviBarIsVisable())
        
        switch isPicking {
        case true:
            setFootViewVisable(makeVisible: !checkFootViewVisable())
            setTabbarVisable(makeVisible: false)
        case false:
            setTabbarVisable(makeVisible: !checkTabbarIsVisiable())
            setFootViewVisable(makeVisible: false)
            
        }
        
    }
    
    @IBOutlet weak var testView: UIView!
    
    func checkFootViewVisable()->Bool {
        guard let testView = self.testView else { return false }
        print("testY=\(testView.frame.maxY),viewY=\(self.view.frame.maxY)")
        return testView.frame.minY < self.view.frame.maxY
    }
    
    func setFootViewVisable(makeVisible:Bool) {
        let footViewHight = self.testView.frame.height
        let footViewMaxY = self.view.frame.maxY
        
        testViewConstraY.constant = makeVisible ? (footViewMaxY - footViewHight) : footViewMaxY
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func hidTabbar(_ sender: Any) {
        searchTF.text = "金色三麥"
        isPicking = true
        
        setTabbarVisable(makeVisible: false)
        setFootViewVisable(makeVisible: true)
        setNaviBarVisable(makeVisible: true)
        

    }
    
    
    @IBOutlet weak var testViewConstraY: NSLayoutConstraint!
    
    
    
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
    func setNaviBarVisable(makeVisible:Bool)
    func setTabbarVisable(makeVisible:Bool)
}

extension SetTabbarAndNavibarVisible where Self:UIViewController {
    
    func setNaviBarVisable(makeVisible:Bool) {
        guard let naviContro = self.navigationController else { return }
        
        let naviBarHight = naviContro.navigationBar.frame.height
        let statusHight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        
        let naviY:CGFloat = makeVisible ? statusHight : -naviBarHight
        UIView.animate(withDuration: 0.3) {
            naviContro.navigationBar.frame.origin.y = naviY
            return
        }
    }
    
     func setTabbarVisable(makeVisible:Bool) {
        guard let tabbarContro = self.tabBarController else { return }
        let tabbarHight = tabbarContro.tabBar.frame.height
        let viewY = self.view.frame.maxY
        
        let tabbarY:CGFloat = (makeVisible ? viewY-tabbarHight : viewY+tabbarHight)
        
        UIView.animate(withDuration: 0.3) {
            tabbarContro.tabBar.frame.origin.y = tabbarY
            return
        }
    }
    
    func checkNaviBarIsVisable()->Bool {
        guard let naviContro = self.navigationController else { return false }
        return naviContro.navigationBar.frame.maxY > 0
    }
    
    func checkTabbarIsVisiable()->Bool {
        guard let tabBarContro = self.tabBarController else { return false }
        return tabBarContro.tabBar.frame.origin.y < self.view.frame.maxY
    }
}


