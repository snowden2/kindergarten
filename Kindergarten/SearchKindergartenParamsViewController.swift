//
//  SearchKindergartenParamsViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 11/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class SearchKindergartenParamsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var selectView: UIView!
    
    var searchKindergartenParamsSelectionType: SearchKindergartenParamsSelectionType?
    var searchKindergartenParamsType: SearchKindergartenParamsType?
    var datasource = Array<String>()
    
    var selectedTypes = Array<String>()
    var selectedTreatmentTypes = Array<String>()
    var selectedWellnessTypes = Array<String>()
    
    var selectedParam: SearchKindergartenParamsType?
    var lastSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.register(UINib(nibName: "SingleSelectionParamsTableViewCell", bundle: nil), forCellReuseIdentifier: "SingleSelectionParamsTableCell")
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"PARAMS_ORIENTATION_CALLBACK"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        if strongSelf.selectedParam == .treatmentParamsType {
                            strongSelf.selectedTreatmentTypes = notification.userInfo?["selectedParams"] as! Array<String>
                        } else if strongSelf.selectedParam == .wellnessParamsType {
                            strongSelf.selectedWellnessTypes = notification.userInfo?["selectedParams"] as! Array<String>
                        }
                        strongSelf.tableview.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableview.allowsMultipleSelection = searchKindergartenParamsSelectionType == .multiParamsSelection
        selectView.isHidden = searchKindergartenParamsSelectionType == .singleParamSelection
        selectAllButton.setTitle(!isSelectedAll() ? "ВЫБРАТЬ ВСЕ" : "СНЯТЬ ВСЕ", for: .normal)
        hintButton.isHidden
         = !(searchKindergartenParamsType == SearchKindergartenParamsType.workingHoursParamsType && searchKindergartenParamsType == SearchKindergartenParamsType.activityParamsType)
        navigationItem.title = searchKindergartenParamsType?.description
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name:Notification.Name(rawValue:"PARAMS_SELECTION_CALLBACK"),
                                        object: nil,
                                        userInfo: ["selectedTypes":selectedTypes,"selectedTreatmentTypes":selectedTreatmentTypes,"selectedWellnessTypes":selectedWellnessTypes])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isSelectedAll() -> Bool {
        var count = 0
        var selected = 0
        if searchKindergartenParamsType == .orientationParamsType {
            count = datasource.count
            selected = selectedTypes.count
            if selectedTreatmentTypes.count > 0 {
                selected += 1
            }
            if selectedWellnessTypes.count > 0 {
                selected += 1
            }
        } else {
            count = datasource.count
            selected = selectedTypes.count
        }
        return selected == count
    }
    
    func selectAll() {
        if searchKindergartenParamsType == .orientationParamsType {
            selectedTypes = datasource
            selectedTypes.remove(at: 1)
            selectedTypes.remove(at: 1)
            selectedTreatmentTypes = DataManager.sharedInstance.getParamsList(by: SearchKindergartenParamsType.treatmentParamsType)!
            selectedWellnessTypes = DataManager.sharedInstance.getParamsList(by: SearchKindergartenParamsType.wellnessParamsType)!
        } else {
            selectedTypes = datasource
        }
        tableview.reloadData()
        selectAllButton.setTitle(!isSelectedAll() ? "ВЫБРАТЬ ВСЕ" : "СНЯТЬ ВСЕ", for: .normal)
    }
    
    func deselectAll() {
        if searchKindergartenParamsType == .orientationParamsType {
            selectedTypes.removeAll()
            selectedTreatmentTypes.removeAll()
            selectedWellnessTypes.removeAll()
        } else {
            selectedTypes.removeAll()
        }
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
        DataManager.sharedInstance.showHint(for: (searchKindergartenParamsType?.description)!)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search Kindergarten Params Detail Segue" {
            if let viewController = segue.destination as? SearchKindergartenParamsDetailViewController {
                viewController.searchKindergartenParamsType = selectedParam
                viewController.datasource = DataManager.sharedInstance.getParamsList(by: selectedParam!)!
                viewController.selectedParams = selectedParam == .treatmentParamsType ? selectedTreatmentTypes : selectedWellnessTypes
            }
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
        
        cell.configCell(param: datasource[indexPath.row], isDisclosurable: searchKindergartenParamsType == .orientationParamsType && (datasource[indexPath.row] == kOrientationTypeHandicap || datasource[indexPath.row] == kOrientationTypeWelness))
        
        if !selectedTypes.contains(datasource[indexPath.row]) {
            cell.switchSelectionIndicator(to: false, andUpdateSelectedInfo: "")
        } else {
            cell.switchSelectionIndicator(to: true, andUpdateSelectedInfo: "")
        }
        
        if datasource[indexPath.row] == kOrientationTypeHandicap {
            let info = selectedTreatmentTypes.count > 0 ? "\(selectedTreatmentTypes.count) из \((DataManager.sharedInstance.getParamsList(by: .treatmentParamsType)?.count)!)" : "0 из \((DataManager.sharedInstance.getParamsList(by: .treatmentParamsType)?.count)!)"
            if selectedTreatmentTypes.count == 0 {
                cell.switchSelectionIndicator(to: false, andUpdateSelectedInfo: info)
            } else {
                cell.switchSelectionIndicator(to: true, andUpdateSelectedInfo: info)
            }
        } else if datasource[indexPath.row] == kOrientationTypeWelness {
            let info = selectedWellnessTypes.count > 0 ? "\(selectedWellnessTypes.count) из \((DataManager.sharedInstance.getParamsList(by: .wellnessParamsType)?.count)!)" : "0 из \((DataManager.sharedInstance.getParamsList(by: .wellnessParamsType)?.count)!)"
            if selectedWellnessTypes.count == 0 {
                cell.switchSelectionIndicator(to: false, andUpdateSelectedInfo: info)
            } else {
                cell.switchSelectionIndicator(to: true, andUpdateSelectedInfo: info)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchKindergartenParamsType == .orientationParamsType {
            if datasource[indexPath.row] == kOrientationTypeHandicap {
                selectedParam = .treatmentParamsType
                self.performSegue(withIdentifier: "Search Kindergarten Params Detail Segue", sender: self)
            } else if datasource[indexPath.row] == kOrientationTypeWelness {
                selectedParam = .wellnessParamsType
                self.performSegue(withIdentifier: "Search Kindergarten Params Detail Segue", sender: self)
            } else {
                if !selectedTypes.contains(datasource[indexPath.row]) {
                    selectedTypes.append(datasource[indexPath.row])
                } else {
                    selectedTypes = selectedTypes.filter { $0 != datasource[indexPath.row] }
                }
                tableview.reloadData()
            }
        } else {
            if searchKindergartenParamsSelectionType == .singleParamSelection && selectedTypes.count > 0 {
                selectedTypes.removeAll()
            }
            if !selectedTypes.contains(datasource[indexPath.row]) {
                selectedTypes.append(datasource[indexPath.row])
            } else {
                selectedTypes = selectedTypes.filter { $0 != datasource[indexPath.row] }
            }
            tableview.reloadData()
        }
    }
    
}
