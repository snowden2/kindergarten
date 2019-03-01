//
//  SearchResultViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 21/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    
    var searchResults = Array<MapSearchResult>()
    var currentSearchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        currentSearchString = searchController.searchBar.text!.trimmingCharacters(in: .whitespaces)
        
        if currentSearchString.characters.count > 0 {
            DataManager.sharedInstance.searchAddress(with: currentSearchString) { (searchResultData) in
                self.searchResults = searchResultData
                self.tableview.reloadData()
                self.tableviewHeightConstraint.constant = self.tableview.contentSize.height
            }
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = searchResults.count == 1 && searchResults.first?.title == "Россия" ? "EmptySearchCell" : "SearchResultCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let mapSearchResult = searchResults[indexPath.row]
        
        cell.title.attributedText = searchResults.count == 1 && searchResults.first?.title == "Россия" ? cell.title.attributedText : DataManager.sharedInstance.highlightText(searchText: currentSearchString, inTargetText: mapSearchResult.title, wthColor: UIColor.yellow)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapSearchResult = searchResults[indexPath.row]
        NotificationCenter.default.post(name:Notification.Name(rawValue:"ADDRESS_DID_SELECT"),
                object: nil,
                userInfo: ["mapSearchResult":mapSearchResult])
        self.dismiss(animated: true, completion: nil)
    }
    
}
