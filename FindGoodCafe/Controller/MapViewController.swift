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

enum MapStatuse {
    
    case selectShope
    case standard
    case clearMap
    
}



class MapViewController: UIViewController, SetTabbarAndNavibarVisible, ShowAlertable, MKMapViewDelegate{
    
    var searchCtrl: UISearchController!
    var searchResult :[CoffeeShop] = [CoffeeShop]()
    var isSearching: Bool = false
    var footVis: Bool = false
    
    let locationManager = CLLocationManager()
    let searchTF = UITextField()
    var isPicking: Bool = false
    var pinsArray: [CoffeeShop] = []
    var selectStore:[CoffeeShop]?
    var downloadError:String?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var urlLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = Session.share.shopesData {
            self.pinsArray = data
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(clickedCancel), name: NSNotification.Name(rawValue: "hidfootview"), object: nil)
        
        setMap()
        addSearchTFInNaviBar()
        addSingleTap()
        loadData()
        
    }
    
    func setMapStatuse(statuse: MapStatuse) {
        switch statuse {
        case .clearMap:
            setTabbarVisable(makeVisible: false)
            setFootViewVisable(makeVisible: false)
            setNaviBarVisable(makeVisible: false)
        case .selectShope:
            setTabbarVisable(makeVisible: false)
            setFootViewVisable(makeVisible: true)
            setNaviBarVisable(makeVisible: true)
        case .standard:
            setTabbarVisable(makeVisible: true)
            setFootViewVisable(makeVisible: false)
            setNaviBarVisable(makeVisible: true)
        }
    }
    
    func setFootView(shope:CoffeeShop?) {
        searchCtrl.searchBar.text = shope?.name ?? ""
        nameLB.text = shope?.name ?? ""
        urlLB.text = shope?.url ?? ""
        
        if shope?.url == "" {
            urlLB.text = "無資料"
        }
        addressLB.text = shope?.address
        if selectStore?.count != 0 && selectStore != nil {
            isPicking = true
            print(selectStore)
        }
        
        
        //TODO:記得用Enum包起來以下
        setMapStatuse(statuse: .selectShope)
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pinCoordinate = view.annotation?.coordinate else { return }
        
        selectStore = self.pinsArray.filter({Double($0.latitude!) == pinCoordinate.latitude && Double($0.longitude!) == pinCoordinate.longitude})
        guard let shope = selectStore?[0] else { return }
        setFootView(shope: shope)
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
        guard let errorString = Session.share.errorString else {
            self.pin(places: pinsArray, map: mapView)
            return
        }
        self.showAlert(title: "Error", content: errorString, completion: nil)
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
        guard let naviCtrl = self.navigationController else { return }
        naviCtrl.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        naviCtrl.navigationBar.shadowImage = UIImage()
        naviCtrl.navigationBar.isTranslucent = true
        naviCtrl.view.backgroundColor = UIColor.clear
        
        
        if let vc = storyboard?.instantiateViewController(identifier: "result") as? SearchResultVC {
            vc.data = self.pinsArray
            searchCtrl = UISearchController(searchResultsController: vc)
            searchCtrl.searchResultsUpdater = vc
            
            self.navigationItem.searchController = searchCtrl
        }
        

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
            if !checkNaviBarIsVisable(){
                print("清楚")
                setMapStatuse(statuse: .clearMap)
                return
            }
            print("選擇")
            setMapStatuse(statuse: .selectShope)
//            setFootViewVisable(makeVisible: !checkFootViewVisable())
//            setTabbarVisable(makeVisible: false)
        case false:
            if !checkNaviBarIsVisable(){
                print("清楚")
                setMapStatuse(statuse: .clearMap)
                return
            }
            print("一般")
            setMapStatuse(statuse: .standard)
//            setTabbarVisable(makeVisible: !checkTabbarIsVisiable())
//            setFootViewVisable(makeVisible: false)
            
        }
        
    }
    
    @IBOutlet weak var footView: UIView!
    
    func checkFootViewVisable() -> Bool {
        guard let footView = self.footView else { return false }
        return footView.frame.minY < self.view.frame.maxY
    }
    
    //FIXME:要解決若使用者沒有點Cancel而點其他地方，footview也要有點cancel的效果
    @objc func clickedCancel() {
        selectStore = nil
        isPicking = false
        setFootView(shope: nil)
        setFootViewVisable(makeVisible: false)
        setTabbarVisable(makeVisible: true)
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
//        isPicking = true
        
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


