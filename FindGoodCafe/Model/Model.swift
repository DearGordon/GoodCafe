//
//  CoffeeShopSQLModel.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/16.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

struct CoffeeShope : Decodable {
    var id: String?
    var name: String?
    var city: String?
    var wifi: Double?
    var seat: Double?
    var quiet: Double?
    var tasty: Double?
    var cheap: Double?
    var music: Double?
    var address: String?
    var latitude: String?
    var longitude: String?
    var url: String?
    var limited_time: String?
    var socket: String?
    var standing_desk: String?
    var mrt: String?
    var open_time: String?
    
    
}
