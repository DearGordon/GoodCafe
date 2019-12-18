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
    
    override func viewDidLoad() {
           super.viewDidLoad()
        
           setMap()
           addSearchTFInNaviBar()
           addSingleTap()
           checkData()
       }
    
    //FIXME:fix some pin cant show information
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
//    let urlSession = URLSession(configuration: .default)
//    func downloadData(url: String ,complite: @escaping (Any?) -> Void) {
//        guard let url = URL(string: urlString) else { return}
//        let task = urlSession.dataTask(with: url) { (data, respone, error) in
//
//            if error != nil{
//                let errorCode = (error! as NSError).code
//                switch errorCode {
//                case -1009:
//                    self.showAlert(title: "沒有網路", content: "請檢查網路連線", completion: nil)
//                    return
//                default:
//                    print(error)
//                    self.showAlert(title: "錯誤", content: "下載檔案時發生未知錯誤\(errorCode)", completion: nil)
//                    return
//                }
//            }
//
//
//            guard let data = data else { return }
//            do{
//                let dataDecoded = try JSONDecoder().decode([CoffeeShop].self, from: data)
//                print("解析完成開始escaping")
//                complite(dataDecoded)
//            } catch {
//                print(error)
//                complite(nil)
//                self.showAlert(title: "錯誤", content: "解析下載檔案失敗)", completion: nil)
//            }
//        }
//
//        task.resume()
//    }
    
    func setMap(){
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkData(){
        if SQLCommon.shared.getSQLData().count != 0 {
            MapViewController.pinsArray = SQLCommon.shared.getSQLData()

            self.pin(places: MapViewController.self.pinsArray, map: self.mapView)
        }else{
            let erroeString: String? = Session.share.downloadData(url: urlString, complite: { (data) in
                MapViewController.self.pinsArray = data as! [CoffeeShop]
                //TODO:test online data first
//                self.pinsArray.forEach({SQLCommon.shared.addData(coffeeShop: $0)})
                self.pin(places: MapViewController.self.pinsArray, map: self.mapView)
            })
            
            if let erroeString = erroeString {
                self.showAlert(title: "Error", content: erroeString, completion: nil)
            }
        }

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
    
    @IBOutlet weak var testView: UIView!
    
    func checkFootViewVisable() -> Bool {
        guard let testView = self.testView else { return false }
        print("testY=\(testView.frame.maxY),viewY=\(self.view.frame.maxY)")
        return testView.frame.minY < self.view.frame.maxY
    }
    
    func setFootViewVisable(makeVisible: Bool) {
        let footViewHight = self.testView.frame.height
        let footViewMaxY = self.view.frame.maxY
        
        testViewConstraY.constant = makeVisible ? (footViewMaxY - footViewHight) : footViewMaxY
        
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
    
    
    @IBOutlet weak var testViewConstraY: NSLayoutConstraint!
    
    
    
}










