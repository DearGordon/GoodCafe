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

class MapViewController: UIViewController, SetTabbarAndNavibarVisible, ShowAlertable, MKMapViewDelegate ,UISearchControllerDelegate {
    
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
    @IBOutlet weak var open_timeLB: UILabel!
    @IBOutlet weak var seatLB: UILabel!
    @IBOutlet weak var cheapLB: UILabel!
    @IBOutlet weak var wifiLB: UILabel!
    @IBOutlet weak var quietLB: UILabel!
    @IBOutlet weak var tastyLB: UILabel!
    @IBOutlet weak var musicLB: UILabel!
    @IBOutlet weak var limited_timeLB: UILabel!
    @IBOutlet weak var socketLB: UILabel!
    @IBOutlet weak var standing_deskLB: UILabel!
    @IBOutlet weak var mrtLB: UILabel!
    @IBOutlet weak var urlLB: UILabel!
    @IBOutlet weak var footView: UIView!
    @IBOutlet weak var footViewConstraY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = Session.share.shopesData {
            self.pinsArray = data
        }
        
        setMap()
        addSearchTFInNaviBar()
        addGestureRecognizer()
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
        guard let shope = shope else { return }
        
        searchCtrl.searchBar.text = shope.name
        nameLB.text = shope.name
        open_timeLB.text = shope.open_time
        addressLB.text = shope.address
        cheapLB.text = String(shope.cheap ?? 0)
        musicLB.text = String(shope.music ?? 0)
        quietLB.text = String(shope.quiet ?? 0)
        seatLB.text = String(shope.seat ?? 0)
        wifiLB.text = String(shope.wifi ?? 0)
        tastyLB.text = String(shope.tasty ?? 0)
        mrtLB.text = shope.mrt
        open_timeLB.text = shope.open_time
        socketLB.text = shope.socket
        standing_deskLB.text = shope.standing_desk
        urlLB.text = shope.url
        
        if shope.url == "" {
            urlLB.text = "無資料"
        }
        addressLB.text = shope.address
        if selectStore?.count != 0 && selectStore != nil {
            isPicking = true
        }
        
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
    
    func addGestureRecognizer() {
        let singleFinger = UITapGestureRecognizer(target: self,action: #selector(singleTap))
        self.view.addGestureRecognizer(singleFinger)
        
        for direction in [UISwipeGestureRecognizer.Direction.up,UISwipeGestureRecognizer.Direction.down] {
            let gr = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            gr.direction = direction
            footView.addGestureRecognizer(gr)
        }
        
    }
    
    @objc func swipe(gr:UISwipeGestureRecognizer) {
        let direction = gr.direction
        let viewMaxY = self.view.frame.maxY
        switch direction {
        case UISwipeGestureRecognizer.Direction.up:
            footViewConstraY.constant = viewMaxY - footView.frame.height
        case UISwipeGestureRecognizer.Direction.down:
            footViewConstraY.constant = viewMaxY - addressLB.frame.maxY
        default:
            print("not going this way")
        }
        UIView.animate(withDuration: 0.3) {
            self.footView.layoutIfNeeded()
        }
    }
    
    @objc func singleTap() {
        if searchTF.isFirstResponder {
            searchTF.endEditing(true)
            return
        }
        setNaviBarVisable(makeVisible: !checkNaviBarIsVisable())
        var status :MapStatuse = .standard
        switch isPicking {
        case true:
            status = checkNaviBarIsVisable() ? .selectShope : .clearMap
        case false:
            status = checkNaviBarIsVisable() ? .standard    : .clearMap
        }
        setMapStatuse(statuse: status)
    }
    
    func checkFootViewVisable() -> Bool {
        guard let footView = self.footView else { return false }
        return footView.frame.minY < self.view.frame.maxY
    }
    
    func setFootViewVisable(makeVisible: Bool) {
        let viewMaxY = self.view.frame.maxY
        
        self.view.bringSubviewToFront(footView)
        
        footViewConstraY.constant = makeVisible ? (viewMaxY - addressLB.frame.maxY) : viewMaxY
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
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


