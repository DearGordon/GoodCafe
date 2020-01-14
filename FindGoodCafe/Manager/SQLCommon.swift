//
//  SQLCommon.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/16.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit
import FMDB

class SQLCommon: NSObject {
    static let shared = SQLCommon()
    
    var fileName: String = "CoffeeStoreData.sqlite"
    var filePath = ""
    var database: FMDatabase!
    
    let creatTableSQL: String =
    """
    create table CoffeeShopTable(
                    id Varchar(100),
                    name Varchar(100),
                    city Varchar(100),
                    wifi Double,
                    seat Double,
                    quiet Double,
                    tasty Double,
                    cheap Double,
                    music Double,
                    address Varchar(100),
                    latitude Varchar(100),
                    longitude Varchar(100),
                    url Varchar(100),
                    limited_time Varchar(100),
                    socket Varchar(100),
                    standing_desk Varchar(100),
                    mrt Varchar(100),
                    open_time Varchar(100)
                    )
    """
    
    
    override init() {
        super.init()
        
        self.filePath = "\(NSHomeDirectory())/Documents/\(self.fileName)"
        print("filePath is = \(filePath)")
        
    }
    
    private func openConnect() -> Bool {
        var isOpen: Bool = false
        self.database = FMDatabase(path: self.filePath)
        guard let database = database else { return false }
        
        if database.open(){
            isOpen = true
        }else{
            isOpen = false
        }
        return isOpen
    }
    

    func creatTable() {
        let fileManager: FileManager = FileManager.default
        let fileExists = fileManager.fileExists(atPath: self.filePath)
        
        switch fileExists {
        case true :
            print("already have file = \(self.filePath)")
            return
        case false :
            if openConnect(){
                self.database?.executeStatements(self.creatTableSQL)
                print("creat TableFile = \(self.filePath)")
                self.database.close()
            }
            return
        }
    }
    
    func addData(coffeeShop:CoffeeShop) {
        if self.openConnect() {
            let addSQL: String = "insert into CoffeeShopTable(id,name,city,wifi,seat,quiet,tasty,cheap,music,address,latitude,longitude,url,limited_time,socket,standing_desk,mrt,open_time) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            let  id: String = coffeeShop.id ?? ""
            let  name: String = coffeeShop.name ?? ""
            let  city: String = coffeeShop.city ?? ""
            let  wifi: Double = coffeeShop.wifi ?? 0
            let  seat: Double = coffeeShop.seat ?? 0
            let  quiet: Double = coffeeShop.quiet ?? 0
            let  tasty: Double = coffeeShop.tasty ?? 0
            let  cheap: Double = coffeeShop.cheap ?? 0
            let  music: Double = coffeeShop.music ?? 0
            let  address: String = coffeeShop.address ?? ""
            let  latitude: String = coffeeShop.latitude ?? ""
            let  longitude: String = coffeeShop.longitude ?? ""
            let  url: String = coffeeShop.url ?? ""
            let  limited_time: String = coffeeShop.limited_time ?? ""
            let  socket: String = coffeeShop.socket ?? ""
            let  standing_desk: String = coffeeShop.standing_desk ?? ""
            let  mrt: String = coffeeShop.mrt ?? ""
            let  open_time: String = coffeeShop.open_time ?? ""
            
            if !self.database.executeUpdate(addSQL, withArgumentsIn: [id,name,city,wifi,seat,quiet,tasty,cheap,music,address,latitude,longitude,url,limited_time,socket,standing_desk,mrt,open_time]){
                print("Error=\(database.lastError()) \n ErrorMessage=\(database.lastErrorMessage())")
            }
            self.database.close()
        }
        
    }
    
    func getSQLData() -> [CoffeeShop] {
        var coffeeShopArray: [CoffeeShop] = [CoffeeShop]()
        
        if self.openConnect() {
            let getDataSQL = " select * from CoffeeShopTable"
            
            do {
                let dataList: FMResultSet = try database.executeQuery(getDataSQL, values: nil)
                while dataList.next() {
                    let coffeeShop:CoffeeShop = CoffeeShop(id: dataList.string(forColumn: "id"), name: dataList.string(forColumn: "name"), city: dataList.string(forColumn: "city"), wifi: dataList.double(forColumn: "wifi"), seat: dataList.double(forColumn: "seat"), quiet: dataList.double(forColumn: "quiet"), tasty: dataList.double(forColumn: "quiet"), cheap: dataList.double(forColumn: "cheap"), music: dataList.double(forColumn: "music"), address: dataList.string(forColumn: "address"), latitude: dataList.string(forColumn: "latitude"), longitude: dataList.string(forColumn: "longitude"), url: dataList.string(forColumn: "url"), limited_time: dataList.string(forColumn: "limited_time"), socket: dataList.string(forColumn: "socket"), standing_desk: dataList.string(forColumn: "standing_desk"), mrt: dataList.string(forColumn: "mrt"), open_time: dataList.string(forColumn: "open_time"))
                    
                    coffeeShopArray.append(coffeeShop)
                }
                
            } catch {
                print("getDataError = \(error.localizedDescription)")
            }
            
        }
        self.database.close()
        return coffeeShopArray
    }

    
}
