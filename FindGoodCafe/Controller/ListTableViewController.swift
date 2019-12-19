//
//  ListTableViewController.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/18.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var seleteIndex:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC: DetailViewController = segue.destination as! DetailViewController
        detailVC.shopeDetail = MapViewController.pinsArray[self.seleteIndex!]
    }

    // MARK: - Table view data source
    // TODO: SearchBar?
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MapViewController.pinsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MapViewController.pinsArray[indexPath.row].name
        cell.detailTextLabel?.text = MapViewController.pinsArray[indexPath.row].address
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.seleteIndex = indexPath.row
        performSegue(withIdentifier: "detail", sender: nil)
    }
    

}
