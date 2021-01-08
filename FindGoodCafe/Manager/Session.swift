//
//  Session.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/12.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

class Session {
    
    private(set) var shopesData: [CoffeeShope]?
    var errorString: String?
    static var share = Session()
    
    let urlString: String = "https://cafenomad.tw/api/v1.2/cafes/taipei"
    let urlSession = URLSession(configuration: .default)
    
    func checkLocalDataExist() {
        SQLCommon.shared.creatTable()
        let semaphore =  DispatchSemaphore(value: 0)
        
        if SQLCommon.shared.getSQLData().count != 0 {
            Session.share.shopesData = SQLCommon.shared.getSQLData()
        } else {
            Session.share.downloadData(url: urlString) { (data) in
                semaphore.signal()
                switch data {
                case .success(let value):
                    Session.share.shopesData = value
                    value.forEach({SQLCommon.shared.addData(coffeeShop: $0)})
                case .failure(let error): Session.share.errorString = error.localizedDescription
                }
            }
            semaphore.wait()
        }
    }
    
    private func downloadData(url: String, complite: @escaping (Result<[CoffeeShope],Error>) -> Void) {
        
        guard let url = URL(string: urlString ) else { return }

        let task = urlSession.dataTask(with: url) { (data, respone, error) in
            if let error = error {
                let errorCode = (error as NSError).code
                switch errorCode {
                case -1009:
                    complite(.failure(error))
                    return
                default:
                    complite(.failure(error))
                    return
                }
            }
            
            guard let data = data else { return }
            
            do{
                let dataDecoded = try JSONDecoder().decode([CoffeeShope].self, from: data)
                complite(.success(dataDecoded))
            } catch {
                complite(.failure(error))
            }
        }
        
        task.resume()
        
    }
    
}
