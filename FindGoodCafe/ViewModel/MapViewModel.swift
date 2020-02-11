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

    var pinsArray: [CoffeeShope] = []
    var reloadView: (()->Void)?
    
    var selectShope: CoffeeShope? = nil {
        didSet {
            reloadView?()
        }
    }
    
    var selectedAnnotationView: MKAnnotationView? {
        didSet{
            guard let shopView = selectedAnnotationView else { return }
            
            if let shopeCoordinate = shopView.annotation?.coordinate {
                
                let store: [CoffeeShope] = pinsArray.filter({Double($0.latitude!) == shopeCoordinate.latitude && Double($0.longitude!) == shopeCoordinate.longitude})
                guard store.count != 0 else { return }
                self.selectShope = store[0]
            }
            reloadView?()
        }
    }
    
    func loadData(array:[CoffeeShope], map: MKMapView ,errorString:@escaping (String?)->Void) {
        guard let error = Session.share.errorString else {
            self.pin(places: array, map: map)
            return
        }
        errorString(error)
    }
    
    func pin(places: [CoffeeShope], map: MKMapView){
        
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
