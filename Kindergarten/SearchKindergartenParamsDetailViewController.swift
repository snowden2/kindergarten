//
//  SearchKindergartenParamsDetailViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 11/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class SearchKindergartenParamsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var selectView: UIView!
    
    var searchKindergartenParamsType: SearchKindergartenParamsType?
    var datasource = Array<String>()
    var selectedParams = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "SingleSelectionParamsTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleSelectionParamsTableCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = searchKindergartenParamsType?.description
        selectAllButton.setTitle(!isSelectedAll() ? "ВЫБРАТЬ ВСЕ" : "СНЯТЬ ВСЕ", for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name:Notification.Name(rawValue:"PARAMS_ORIENTATION_CALLBACK"),
                object: nil,
                userInfo: ["selectedParams":selectedParams])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isSelectedAll() -> Bool {
        return selectedParams.count == datasource.count
    }
    
    func selectAll() {
        selectedParams = datasource
        tableview.reloadData()
        selectAllButton.setTitle(!isSelectedAll() ? "ВЫБРАТЬ ВСЕ" : "СНЯТЬ ВСЕ", for: .normal)
    }
    
    func deselectAll() {
        selectedParams.removeAll()
        tableview.reloadData()
        selectAllButton.setTitle(!isSelectedAll() ? "ВЫБРАТЬ ВСЕ" : "СНЯТЬ ВСЕ", for: .normal)
    }
    
    @IBAction func selectAllAction(_ sender: Any) {
        if !isSelectedAll() {
            selectAll()
        } else {
            deselectAll()
        }
    }
    
    @IBAction func showHint(_ sender: Any) {
        if searchKindergartenParamsType == .treatmentParamsType {
            DataManager.sharedInstance.showHint(for: kOrientationTypeHandicap)
        } else {
            DataManager.sharedInstance.showHint(for: kOrientationTypeWelness)
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SingleSelectionParamsTableCell", for: indexPath as IndexPath) as? SingleSelectionParamsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configCell(param: datasource[indexPath.row], isDisclosurable: false)
        
        if !selectedParams.contains(datasource[indexPath.row]) {
            cell.switchSelectionIndicator(to: false, andUpdateSelectedInfo: "")
        } else {
            cell.switchSelectionIndicator(to: true, andUpdateSelectedInfo: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !selectedParams.contains(datasource[indexPath.row]) {
            selectedParams.append(datasource[indexPath.row])
        } else {
            selectedParams = selectedParams.filter { $0 != datasource[indexPath.row] }
        }
        tableview.reloadData()
    }

}
