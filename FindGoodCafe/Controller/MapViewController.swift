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



class MapViewController: UIViewController, ShowAlertable ,MKMapViewDelegate {
    
    var mapViewModel = MapViewModel()
    
    var searchCtrl: UISearchController!
    let locationManager = CLLocationManager()
    var isPicking: Bool = false
    
    var downloadError:String?
    var mapStatus: MapStatuse = .Standard
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var footViewConstraY: NSLayoutConstraint!
    @IBOutlet weak var footView: FootView!
    
    @IBAction func userLocationBtn(_ sender: Any) {
        self.zoomToUserLocat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMap()
        loadShopes()
        addSearchBarInNaviBar()
        addGestureRecognizer()
        laodPin()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        zoomToUserLocat()
    }
    
    private func setMap(){
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func loadShopes() {
        guard let data = Session.share.shopesData else { return }
        mapViewModel.pinsArray = data
    }
    
    private func laodPin() {
        mapViewModel.loadData(array: mapViewModel.pinsArray, map: mapView) { errorString in
            guard let errorString = errorString else {
                DispatchQueue.main.async {
                    self.mapView.reloadInputViews()
                }
                return
            }
            self.showAlert(title: "Error", content: errorString, completion: nil)
        }
    }
    
    func bindViewModel() {
        mapViewModel.reloadView = {
            guard let shope = self.mapViewModel.selectShope else { return }
            self.searchCtrl.searchBar.text = shope.name
            self.footView.setFootViewData(viewModel: shope)
            self.setMapStatuse(statuse: .SelectShope)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapViewModel.selectAnnotationView = view
        isPicking = true
    }
    
    func setMapStatuse(statuse: MapStatuse) {
        switch statuse {
        case .ClearMap:
            setTabbarVisable(makeVisible: false)
            setFootViewVisable(makeVisible: false)
            setNaviBarVisable(makeVisible: false)
        case .SelectShope:
            setTabbarVisable(makeVisible: false)
            setFootViewVisable(makeVisible: true)
            setNaviBarVisable(makeVisible: true)
        case .Standard:
            setTabbarVisable(makeVisible: true)
            setFootViewVisable(makeVisible: false)
            setNaviBarVisable(makeVisible: true)
        }
    }
    
    private func zoomToUserLocat() {
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200,longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    
}








