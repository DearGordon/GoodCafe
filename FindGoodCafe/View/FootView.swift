//
//  FootViewModelView.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2020/1/13.
//  Copyright © 2020 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

class FootView: UIView {
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var open_timeLB: UILabel!
    @IBOutlet weak var seatLB: UILabel!
    @IBOutlet weak var cheapLB: UILabel!
    @IBOutlet weak var wifiLB: UILabel!
    @IBOutlet weak var quietLB: UILabel!
    @IBOutlet weak var tastyLB: UILabel!
    @IBOutlet weak var musicLB: UILabel!
    @IBOutlet weak var limited_timeLB: UILabel!
    @IBOutlet weak var socketLB: UILabel!
    @IBOutlet weak var standing_deskLB: UILabel!
    @IBOutlet weak var mrtLB: UILabel!
    @IBOutlet weak var urlLB: UILabel!
    
    func setFootViewData(viewModel: CoffeeShop) {
        self.nameLB.text = viewModel.name
        self.open_timeLB.text = viewModel.open_time
        self.addressLB.text = viewModel.address
        self.cheapLB.text = String(viewModel.cheap ?? 0)
        self.musicLB.text = String(viewModel.music ?? 0)
        self.quietLB.text = String(viewModel.quiet ?? 0)
        self.seatLB.text = String(viewModel.seat ?? 0)
        self.wifiLB.text = String(viewModel.wifi ?? 0)
        self.tastyLB.text = String(viewModel.tasty ?? 0)
        self.mrtLB.text = viewModel.mrt
        self.open_timeLB.text = viewModel.open_time
        self.socketLB.text = viewModel.socket
        self.standing_deskLB.text = viewModel.standing_desk
        self.urlLB.text = viewModel.url
        
        if viewModel.url == "" {
            self.urlLB.text = "無資料"
        }
        self.addressLB.text = viewModel.address

    }
    
    
    
}
