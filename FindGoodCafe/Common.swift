//
//  Common.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/12.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

protocol ShowAlertable {
    
    func showAlert(title: String, content: String, actions: [UIAlertAction]?, preferredStyle: UIAlertController.Style, completion: (() -> ())?)
}

extension ShowAlertable where Self: UIViewController {
    
    func showAlert(title: String, content: String, actions: [UIAlertAction]? = nil, preferredStyle: UIAlertController.Style = .alert, completion: (() -> ())?) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: preferredStyle)
        if let actions = actions {
            actions.forEach({ alert.addAction($0) })
        }else{
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: completion)
        }
    }
}
