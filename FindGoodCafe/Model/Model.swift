//
//  CoffeeShopSQLModel.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/16.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

//class CoffeeShopSQLModel: NSObject {
//    var id: String?
//    var name: String?
//    var city: String?
//    var wifi: Double?
//    var seat: Double?
//    var quiet: Double?
//    var tasty: Double?
//    var cheap: Double?
//    var music: Double?
//    var address: String?
//    var latitude: String?
//    var longitude: String?
//    var url: String?
//    var limited_time: String?
//    var socket: String?
//    var standing_desk: String?
//    var mrt: String?
//    var open_time: String?
//
//    init(coffeeshop:CoffeeShop) {
//        self.id = coffeeshop.id
//        self.name = coffeeshop.name
//        self.city = coffeeshop.city
//        self.wifi = coffeeshop.wifi
//        self.seat = coffeeshop.seat
//        self.quiet = coffeeshop.quiet
//        self.tasty = coffeeshop.tasty
//        self.cheap = coffeeshop.cheap
//        self.music = coffeeshop.music
//        self.address = coffeeshop.address
//        self.latitude = coffeeshop.latitude
//        self.longitude = coffeeshop.longitude
//        self.url = coffeeshop.url
//        self.limited_time = coffeeshop.limited_time
//        self.socket = coffeeshop.socket
//        self.standing_desk = coffeeshop.standing_desk
//        self.mrt = coffeeshop.mrt
//        self.open_time = coffeeshop.open_time
//    }
//
//}

struct CoffeeShop : Decodable {
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
