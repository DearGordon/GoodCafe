//
//  DetailViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/18.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var shopeDetail: CoffeeShop?

    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
    }
    
    func setText() {
        guard let shopeDetail = shopeDetail else { return }
        nameLB.text = shopeDetail.name
        wifiLB.text = String(shopeDetail.wifi ?? 0)
        seatLB.text = String(shopeDetail.seat ?? 0)
        quietLB.text = String(shopeDetail.quiet ?? 0)
        tastyLB.text = String(shopeDetail.tasty ?? 0)
        cheapLB.text = String(shopeDetail.cheap ?? 0)
        musicLB.text = String(shopeDetail.music ?? 0)
        addressLB.text = shopeDetail.address
        urlLB.text = shopeDetail.url
        limited_timeLB.text = shopeDetail.limited_time
        socketLB.text = shopeDetail.socket
        standing_deskLB.text = shopeDetail.standing_desk
        mrtLB.text = shopeDetail.mrt
        open_timeLB.text = shopeDetail.open_time
    }
    
    
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var wifiLB: UILabel!
    @IBOutlet weak var seatLB: UILabel!
    @IBOutlet weak var quietLB: UILabel!
    @IBOutlet weak var tastyLB: UILabel!
    @IBOutlet weak var cheapLB: UILabel!
    @IBOutlet weak var musicLB: UILabel!
    @IBOutlet weak var addressLB: UILabel!
    @IBOutlet weak var urlLB: UILabel!
    @IBOutlet weak var limited_timeLB: UILabel!
    @IBOutlet weak var socketLB: UILabel!
    @IBOutlet weak var standing_deskLB: UILabel!
    @IBOutlet weak var mrtLB: UILabel!
    @IBOutlet weak var open_timeLB: UILabel!
}
