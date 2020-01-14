//
//  ListTableViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/18.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var listViewModel = ListViewModel()
    var shopeData :[CoffeeShop] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var seleteIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
       initView()
    }
   
    func initView() {
        self.tableView.separatorStyle = .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC: DetailViewController = segue.destination as! DetailViewController
        guard let shopesArray = Session.share.shopesData,
            let selectIndex = self.seleteIndex else { return }
        detailVC.shopeDetail = shopesArray[selectIndex]
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let shopesData = Session.share.shopesData else {
            return 0
        }
        
        return shopesData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let shopesData = Session.share.shopesData {
            cell.textLabel?.text = shopesData[indexPath.row].name
            cell.detailTextLabel?.text = shopesData[indexPath.row].address
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.seleteIndex = indexPath.row
        performSegue(withIdentifier: "detail", sender: nil)
    }
    

}
