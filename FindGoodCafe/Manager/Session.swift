//
//  Session.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/12.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

struct Session {
    
    private(set) var shopesData: [CoffeeShop]?
    var errorString: String?
    static var share = Session()
    
    let urlString: String = "https://cafenomad.tw/api/v1.2/cafes/taipei"
    let urlSession = URLSession(configuration: .default)
    
    func checkDataIsOK(){
        let semaphore =  DispatchSemaphore(value: 0)
        
        if SQLCommon.shared.getSQLData().count != 0 {
            Session.share.shopesData = SQLCommon.shared.getSQLData()
        }else{
            
            let urlString: String = "https://cafenomad.tw/api/v1.2/cafes/taipei"
            Session.share.downloadData(url: urlString) { (data) in
                semaphore.signal()
                switch data {
                case .success(let value): Session.share.shopesData = value
                case .failure(let error): Session.share.errorString = error.localizedDescription
                }
            }
            semaphore.wait()
        }
    }
    
    private func downloadData(url: String, complite: @escaping (Result<[CoffeeShop],Error>) -> Void) {
        
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
                let dataDecoded = try JSONDecoder().decode([CoffeeShop].self, from: data)
                complite(.success(dataDecoded))
            } catch {
                complite(.failure(error))
            }
        }
        
        task.resume()
        
    }
    
}
