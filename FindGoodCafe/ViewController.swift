//
//  ViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/5.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//
import UIKit

extension UITextField {
    
    func setMyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "clearBtn"), for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    @objc func clear(sender : AnyObject) {
        print("我想實作一個ViewController裡面的的func")
        self.text = ""
    }
    
}

class ViewController: UIViewController,SetTabbarAndNavibarVisible,ShowAlertable {

    let searchTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchTFInNaviBar()
        addSingleTap()
        
    }
    
    func addSearchTFInNaviBar(){
        guard let naviContro = self.navigationController else { return }
        naviContro.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        naviContro.navigationBar.shadowImage = UIImage()
        naviContro.navigationBar.isTranslucent = true
        naviContro.view.backgroundColor = UIColor.clear
        
        searchTF.placeholder = "請搜尋你要的地點"
        searchTF.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*2/3, height: 30)
        searchTF.setMyClearButton()
        
        self.navigationItem.titleView = searchTF
    }
    
    
    
    func addSingleTap(){
        let singleFinger = UITapGestureRecognizer(
        target:self,
        action:#selector(singleTap))
        self.view.addGestureRecognizer(singleFinger)
    }
    
    @objc func singleTap(){
        if searchTF.isFirstResponder{
            searchTF.endEditing(true)
            return
        }
        setNaviBarVisable(makeVisible:!checkNaviBarIsVisable())
        setTabbarVisable(makeVisible:!checkTabbarIsVisiable())
        setFootViewVisable(makeVisible: searchTF.text != "")
    }
    
    @IBOutlet weak var testView: UIView!
    
    func checkFootViewVisable()->Bool{
        guard let testView = self.testView else { return false }
        print("testY=\(testView.frame.maxY),viewY=\(self.view.frame.maxY)")
        return testView.frame.minY < self.view.frame.maxY
    }
    
    func setFootViewVisable(makeVisible:Bool){
        let TestviewHight = self.testView.frame.height
        let viewMaxY = self.view.frame.maxY
//        let makeVisible = !checkFootViewVisable()
        
        testViewConstraY.constant = makeVisible ? (viewMaxY - TestviewHight) : viewMaxY
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func hidTabbar(_ sender: Any) {
        searchTF.text = "點到按鈕了"
        
        setTabbarVisable(makeVisible: false)
        setFootViewVisable(makeVisible: true)
        
        //把搜尋列加上x，點x要把tableview縮下去跟把文字清空
        
//        switch checkTabbarIsVisiable() {
//        case true:
//            setTabbarVisable(makeVisible:false)
//            setFootViewVisable(makeVisible:true)
//            return
//        case false:
//           setFootViewVisable(makeVisible:true)
//           setNaviBarVisable(makeVisible:true)
//            return
//        }
        
//        showAlert(title: "你好", content: "內容", completion: nil)
        
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

extension SetTabbarAndNavibarVisible where Self:UIViewController{
    
    func setNaviBarVisable(makeVisible:Bool){
        guard let naviContro = self.navigationController else { return }
//        let makeVisible = !(checkNaviBarIsVisable())
        
        
        let naviBarHight = naviContro.navigationBar.frame.height + 20   //要想辦法偵測statusbar的高度
        
        let naviY:CGFloat = makeVisible ? naviBarHight:-naviBarHight
        UIView.animate(withDuration: 0.3) {
            naviContro.navigationBar.frame = naviContro.navigationBar.frame.offsetBy(dx: 0, dy: naviY)
            return
        }
    }
    
     func setTabbarVisable(makeVisible:Bool){
        guard let tabbarContro = self.tabBarController else { return }
//        let makeVisible = !(checkTabbarIsVisiable())
        let tabbarHight = tabbarContro.tabBar.frame.height
        
        let tabbarY:CGFloat = (makeVisible ? -tabbarHight : tabbarHight)
        
        UIView.animate(withDuration: 0.3) {
            tabbarContro.tabBar.frame = tabbarContro.tabBar.frame.offsetBy(dx: 0, dy: tabbarY)
            return
        }
    }
    
    func checkNaviBarIsVisable()->Bool{
        guard let naviContro = self.navigationController else { return false }
        return naviContro.navigationBar.frame.maxY > 0
    }
    
    func checkTabbarIsVisiable()->Bool{
        guard let tabBarContro = self.tabBarController else { return false }
        return tabBarContro.tabBar.frame.origin.y < self.view.frame.maxY
    }
}


