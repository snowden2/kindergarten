//
//  SingleSelectionListViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 28/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class SingleSelectionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableview: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var viewModel: SingleSelectionListViewModel! {
        didSet {
            self.viewModel.datasourceDidLoad = { [unowned self] viewModel in
                self.tableview.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "Поиск"
        tableview.tableHeaderView = searchController.searchBar
    }

    override func viewDidDisappear(_ animated: Bool) {
        searchController.isActive = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredDatasource != nil ? (self.viewModel.filteredDatasource?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionListCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = self.viewModel.type == .singleSelectionListRegs ? "\(((self.viewModel.filteredDatasource?[indexPath.row] as! Dictionary<String, Any>)["fullname"])!)" : (self.viewModel.filteredDatasource?[indexPath.row] as! Municipality).name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.type == .singleSelectionListRegs {
            let region = self.viewModel.filteredDatasource?[indexPath.row] as! Dictionary<String, Any>
            NotificationCenter.default.post(name:Notification.Name(rawValue:"REGS_DID_SELECT"),
                                            object: nil,
                                            userInfo: ["regId":region["id"] as! Int,"regName":region["fullname"] as! String])
        } else {
            let municipality = self.viewModel.filteredDatasource?[indexPath.row] as! Municipality
            NotificationCenter.default.post(name:Notification.Name(rawValue:"MUNS_DID_SELECT"),
                                            object: nil,
                                            userInfo: ["municipality":municipality])
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            self.viewModel.filteredDatasource = self.viewModel.datasource
        } else {
            if self.viewModel.type == .singleSelectionListRegs {
                self.viewModel.filteredDatasource = (self.viewModel.datasource as! Array<Dictionary<String, Any>>).filter { "\($0["fullname"]!)".lowercased().contains(searchController.searchBar.text!.lowercased()) }
            } else {
                self.viewModel.filteredDatasource = (self.viewModel.datasource as! Array<Municipality>).filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
            }
        }
        
        tableview.reloadData()
    }
    
}
