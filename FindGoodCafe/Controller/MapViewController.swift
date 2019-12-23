//
//  ViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/5.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//
import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController, SetTabbarAndNavibarVisible, ShowAlertable, MKMapViewDelegate{
    
    let locationManager = CLLocationManager()
    let searchTF = UITextField()
    var isPicking: Bool = false
    static var pinsArray: [CoffeeShop] = []
    @IBOutlet weak var mapView: MKMapView!
    var selectStore:[CoffeeShop]?
    let searchBar = UISearchBar()
    
    var downloadError:String?
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var urlLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMap()
        addSearchTFInNaviBar()
        addSingleTap()
        loadData()
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pinCoordinate = view.annotation?.coordinate else { return }
        
        selectStore = MapViewController.pinsArray.filter({Double($0.latitude!) == pinCoordinate.latitude && Double($0.longitude!) == pinCoordinate.longitude})
        
        searchTF.text = selectStore?[0].name
        nameLB.text = selectStore?[0].name
        urlLB.text = selectStore?[0].url
        
        if selectStore?[0].url == "" {
            urlLB.text = "無資料"
        }
        addressLB.text = selectStore?[0].address
        
        isPicking = true
        
        //TODO:記得用Enum包起來以下
        setTabbarVisable(makeVisible: false)
        setFootViewVisable(makeVisible: true)
        setNaviBarVisable(makeVisible: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zoomToUserLocat()
    }
    
    //FIXME:currentLocation Btn Autolayout
    @IBAction func userLocationBtn(_ sender: Any) {
        self.zoomToUserLocat()
        
    }
    
    func zoomToUserLocat() {
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200,longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    
    func pin(places: [CoffeeShop], map: MKMapView){
        
        for place in places {
            let pin = MKPointAnnotation()
            guard let placeLat = Double(place.latitude!),
                let placeLong = Double(place.longitude!) else { return }
            
            pin.coordinate = CLLocationCoordinate2D(latitude: placeLat, longitude: placeLong)
            pin.title = place.name ?? "未知店名"
            pin.subtitle = place.address ?? "未知地址"
            map.addAnnotation(pin)
        }
        DispatchQueue.main.async {
            map.reloadInputViews()
            print("重整地圖")
        }
        
        
    }
    
    
    
    
    let urlString: String = "https://cafenomad.tw/api/v1.2/cafes/taipei"

    
    func setMap(){
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func loadData(){
        guard let shopesArray = Session.share.shopesData else {
            self.showAlert(title: "Error", content: Session.share.errorString ?? "", completion: nil)
            return
        }
        self.pin(places: shopesArray, map: mapView)
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
        
        searchTF.attributedPlaceholder = NSAttributedString(string: "請搜尋你要的地點", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchTF.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*2/3, height: 30)
        setMyClearButton()
        
//        self.navigationItem.titleView = searchTF
        self.navigationItem.titleView = searchBar
    }
    
    
    
    func addSingleTap() {
        let singleFinger = UITapGestureRecognizer(
            target: self,
            action: #selector(singleTap))
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
    
    @IBOutlet weak var footView: UIView!
    
    func checkFootViewVisable() -> Bool {
        guard let testView = self.footView else { return false }
        print("testY=\(testView.frame.maxY),viewY=\(self.view.frame.maxY)")
        return testView.frame.minY < self.view.frame.maxY
    }
    
    func setFootViewVisable(makeVisible: Bool) {
        let footViewHight = self.footView.frame.height
        let footViewMaxY = self.view.frame.maxY
        
        self.view.bringSubviewToFront(footView)
        
        footViewConstraY.constant = makeVisible ? (footViewMaxY - footViewHight) : footViewMaxY
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pressPin(_ sender: Any) {
        searchTF.text = "金色三麥"
        isPicking = true
        
        setTabbarVisable(makeVisible: false)
        setFootViewVisable(makeVisible: true)
        setNaviBarVisable(makeVisible: true)
    }
    
    
    @IBOutlet weak var footViewConstraY: NSLayoutConstraint!
    
    
    
}









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


