//
//  MapViewModel.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2020/1/10.
//  Copyright © 2020 Kuan-Chieh Feng. All rights reserved.
//

import UIKit
import MapKit

enum MapStatuse {
    case SelectShope
    case Standard
    case ClearMap
}

class MapViewModel {
    
    var selectShope: CoffeeShop?
    var pinsArray: [CoffeeShop] = []
    var reloadView: (()->Void)?
    
    var selectAnnotationView: MKAnnotationView? {
        didSet{
            guard let shopView = selectAnnotationView else { return }
            
            if let shopeCoordinate = shopView.annotation?.coordinate {
                
                let store: [CoffeeShop] = pinsArray.filter({Double($0.latitude!) == shopeCoordinate.latitude && Double($0.longitude!) == shopeCoordinate.longitude})
                guard store.count != 0 else { return }
                selectShope = store[0]
            }
            reloadView?()
        }
    }
    
    func loadData(array:[CoffeeShop], map: MKMapView ,errorString:@escaping (String?)->Void) {
        guard Session.share.errorString != nil else {
            self.pin(places: array, map: map)
            return
        }
        errorString(Session.share.errorString)
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
        
    }
    
    
    
    
}
