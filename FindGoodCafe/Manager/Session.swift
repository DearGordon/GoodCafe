//
//  Session.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/12.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

class Session: NSObject {
    
    static let share = Session()
    
    let urlString: String = "https://cafenomad.tw/api/v1.2/cafes/taipei"
    let urlSession = URLSession(configuration: .default)
    
    func downloadData(url: String ,complite: @escaping (Any?) -> Void) -> String?{
        var errorString: String?
        guard let url = URL(string: urlString) else { return errorString}
        let task = urlSession.dataTask(with: url) { (data, respone, error) in
            
            if error != nil{
                let errorCode = (error! as NSError).code
                switch errorCode {
                case -1009:
                    errorString = "沒有網路"
//                    self.showAlert(title: "沒有網路", content: "請檢查網路連線", completion: nil)
                    return
                default:
                    errorString = "\(errorCode)"
//                    self.showAlert(title: "錯誤", content: "下載檔案時發生未知錯誤\(errorCode)", completion: nil)
                    return
                }
            }
            
            
            guard let data = data else { return }
            do{
                let dataDecoded = try JSONDecoder().decode([CoffeeShop].self, from: data)
                print("解析完成開始escaping")
                complite(dataDecoded)
            } catch {
                print(error)
                complite(nil)
                errorString = "fail to Decod data"
//                self.showAlert(title: "錯誤", content: "解析下載檔案失敗)", completion: nil)
            }
        }
        
        task.resume()
        
        return errorString
    }

}
