//
//  SearchResultVC.swift
//  FindGoodCafe
//
//  Created by Kuan-Chieh Feng on 2019/12/25.
//  Copyright © 2019 Kuan-Chieh Feng. All rights reserved.
//

import UIKit

class SearchResultVC: UITableViewController ,UISearchResultsUpdating ,UISearchBarDelegate {
    
    var filterList: [CoffeeShop]?
    var data :[CoffeeShop]?
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.searchBar.delegate = self
        if let searchText = searchController.searchBar.text {
            filterList = data?.filter({ (shope) -> Bool in
                let name = shope.name ?? "未知的名字"
                return name.range(of: searchText) != nil
            })
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hidfootview"), object: .none)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.delegate = self
        if searchBar.text == "" {
            let mapVC = MapViewController()
            mapVC.footVis = false
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filterList?[indexPath.row].name ?? "未知"
        return cell
    }
    
}


