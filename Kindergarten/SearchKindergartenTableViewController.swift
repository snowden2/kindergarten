//
//  SearchKindergartenTableViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 28/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class SearchKindergartenTableViewController: UITableViewController {

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var municipality: UILabel!
    @IBOutlet weak var propertyType: UILabel!
    @IBOutlet weak var functionType: UILabel!
    @IBOutlet weak var structureType: UILabel!
    @IBOutlet weak var licence: UILabel!
    @IBOutlet weak var ageCategory: UILabel!
    @IBOutlet weak var orientationType: UILabel!
    @IBOutlet weak var workingHoursType: UILabel!
    @IBOutlet weak var activityType: UILabel!
    @IBOutlet weak var freeSpace: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    var regId = 45
    var munId = 0
    var ageFrom = ""
    var ageTo = ""
    var propertyTypeParam = ""
    var functionTypeParam = ""
    var structureTypeParam = Array<String>()
    var orientationTypeParam = Array<String>()
    var treatmentTypeParam = Array<String>()
    var wellnessTypeParam = Array<String>()
    var workingHoursTypeParam = Array<String>()
    var activityTypeParam = Array<String>()
    
    var singleSelectionType = SingleSelectionListType.singleSelectionListRegs
    var searchKindergartenParamsSelectionType = SearchKindergartenParamsSelectionType.singleParamSelection
    var searchKindergartenParamsType = SearchKindergartenParamsType.propertyParamsType
    var selectedTypes = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        
        structureTypeParam = DataManager.sharedInstance.getParamsList(by: SearchKindergartenParamsType.structureParamsType)!
        workingHoursTypeParam = DataManager.sharedInstance.getParamsList(by: SearchKindergartenParamsType.workingHoursParamsType)!
        orientationTypeParam = DataManager.sharedInstance.getParamsList(by: SearchKindergartenParamsType.orientationParamsType)!
        orientationTypeParam.remove(at: 1)
        orientationTypeParam.remove(at: 1)
        treatmentTypeParam = DataManager.sharedInstance.getParamsList(by: SearchKindergartenParamsType.treatmentParamsType)!
        wellnessTypeParam = DataManager.sharedInstance.getParamsList(by: SearchKindergartenParamsType.wellnessParamsType)!
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"PARAMS_AGE_CALLBACK"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.ageFrom = (notification.userInfo?["ageInterval"] as! Array<String>).first!
                        strongSelf.ageTo = (notification.userInfo?["ageInterval"] as! Array<String>).last!
                        
                        let ageFromComps = strongSelf.ageFrom.components(separatedBy: " ")
                        let ageToComps = strongSelf.ageTo.components(separatedBy: " ")
                        
                        let ageFrom = (ageFromComps.first?.contains("6"))! ? "6 м." : ageFromComps.first
                        let ageTo = ageToComps.first
                        
                        strongSelf.ageCategory.text = "От \(ageFrom!) до \(ageTo!) лет"
        }
        nc.addObserver(forName:Notification.Name(rawValue:"REGS_DID_SELECT"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.regId = notification.userInfo?["regId"] as! Int
                        strongSelf.region.text = notification.userInfo?["regName"] as? String
                        UserDefaults.standard.set(strongSelf.region.text, forKey: "SELECTED_REGION")
                        UserDefaults.standard.synchronize()
                        strongSelf.tableView.reloadData()
        }
        nc.addObserver(forName:Notification.Name(rawValue:"MUNS_DID_SELECT"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.bottomView.isHidden = false
                        let muns = notification.userInfo?["municipality"] as! Municipality
                        strongSelf.munId = muns.id
                        strongSelf.municipality.text = muns.name
                        strongSelf.tableView.reloadData()
        }
        nc.addObserver(forName:Notification.Name(rawValue:"PARAMS_SELECTION_CALLBACK"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        if strongSelf.searchKindergartenParamsType == .propertyParamsType {
                            if (notification.userInfo?["selectedTypes"] as! Array<String>).count > 0 {
                                strongSelf.propertyTypeParam = (notification.userInfo?["selectedTypes"] as! Array<String>).first!
                            } else {
                                strongSelf.propertyTypeParam = "Не важно"
                            }
                            strongSelf.propertyType.text = strongSelf.propertyTypeParam
                        } else if strongSelf.searchKindergartenParamsType == .functionParamsType {
                            if (notification.userInfo?["selectedTypes"] as! Array<String>).count > 0 {
                                strongSelf.functionTypeParam = (notification.userInfo?["selectedTypes"] as! Array<String>).first!
                            } else {
                                strongSelf.functionTypeParam = "Не важно"
                            }
                            strongSelf.functionType.text = strongSelf.functionTypeParam
                        } else if strongSelf.searchKindergartenParamsType == .structureParamsType {
                            strongSelf.structureTypeParam = notification.userInfo?["selectedTypes"] as! Array<String>
                            strongSelf.structureType.text = strongSelf.structureTypeParam.count > 0 ? "\(strongSelf.structureTypeParam.count) из \((DataManager.sharedInstance.getParamsList(by: .structureParamsType)?.count)!)" : "0 из 3"
                        } else if strongSelf.searchKindergartenParamsType == .orientationParamsType {
                            strongSelf.orientationTypeParam = notification.userInfo?["selectedTypes"] as! Array<String>
                            strongSelf.treatmentTypeParam = notification.userInfo?["selectedTreatmentTypes"] as! Array<String>
                            strongSelf.wellnessTypeParam = notification.userInfo?["selectedWellnessTypes"] as! Array<String>
                            var count = 0
                            if strongSelf.orientationTypeParam.count > 0 {
                                count = strongSelf.orientationTypeParam.count
                            }
                            if strongSelf.treatmentTypeParam.count > 0 {
                                count += 1
                            }
                            if strongSelf.wellnessTypeParam.count > 0 {
                                count += 1
                            }
                            strongSelf.orientationType.text = count > 0 ? "\(count) из \(((DataManager.sharedInstance.getParamsList(by: .orientationParamsType)?.count)!))" : "0 из 5"
                        } else if strongSelf.searchKindergartenParamsType == .workingHoursParamsType {
                            strongSelf.workingHoursTypeParam = notification.userInfo?["selectedTypes"] as! Array<String>
                            strongSelf.workingHoursType.text = strongSelf.workingHoursTypeParam.count > 0 ? "\(strongSelf.workingHoursTypeParam.count) из \((DataManager.sharedInstance.getParamsList(by: .workingHoursParamsType)?.count)!)" : "0 из 5"
                        } else if strongSelf.searchKindergartenParamsType == .activityParamsType {
                            strongSelf.activityTypeParam = notification.userInfo?["selectedTypes"] as! Array<String>
                            if strongSelf.activityTypeParam.count > 1 || strongSelf.activityTypeParam.count == 0 {
                                strongSelf.activityType.text = "Не важно"
                            } else if strongSelf.activityTypeParam.count == 1 {
                                strongSelf.activityType.text = strongSelf.activityTypeParam.first
                            }
                        }
                        strongSelf.tableview.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationController!.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController!.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        bottomView.isHidden = munId == 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeDictionaryForSearchRequest() -> Dictionary<String, String> {
        var dict = Dictionary<String, String>()
        
        if regId > 0 {
            dict["regId"] = "\(regId)"
        }
        
        if munId > 0 {
            dict["munId"] = "\(munId)"
        }
        
        if propertyTypeParam.characters.count > 0 {
            if !propertyTypeParam.contains(kPropertyTypeAny) {
                var propertyTypeUrlComponent = ""
                if propertyTypeParam.contains(kPropertyTypeStateOrMunicipal) {
                    propertyTypeUrlComponent = "1,2,7"
                } else {
                    propertyTypeUrlComponent = "3,4,5,6"
                }
                dict["type"] = propertyTypeUrlComponent
            }
        }
        
        if functionTypeParam.characters.count > 0 {
            if !propertyTypeParam.contains(kFunctionStatusAny) {
                dict["status"] = "1"
            }
        }
        
        if structureTypeParam.count > 0 {
            var structure = Array<String>()
            for item in structureTypeParam {
                if item.contains(kStructureTypeKindergarten) {
                    structure.append("1")
                } else if item.contains(kStructureTypeSchoolGroups) {
                    structure.append("2")
                } else {
                    structure.append("3")
                    structure.append("4")
                }
            }
            dict["structure"] = structure.joined(separator: ",")
        }
        
        dict["licence"] = (licence.text?.contains("Да"))! ? "1" : "0"
        
        if ageFrom.characters.count > 0 {
            var ageFromTemp = ""
            
            if ageFrom.contains(kAgeSixMonths) {
                ageFromTemp = "0.5"
            } else {
                ageFromTemp = ageFrom.components(separatedBy: " ").first!
            }
            
            dict["age_from"] = ageFromTemp
        }
        
        if ageTo.characters.count > 0 {
            var ageToTemp = ""
            
            if ageTo.contains(kAgeSixMonths) {
                ageToTemp = "0.5"
            } else {
                ageToTemp = ageTo.components(separatedBy: " ").first!
            }
            
            dict["age_to"] = ageToTemp
        }
        
        if orientationTypeParam.count > 0 {
            var orientationType = Array<String>()
            for item in orientationTypeParam {
                if item.contains(kOrientationTypeCommon) {
                    orientationType.append("1")
                } else if item.contains(kOrientationTypeCare) {
                    orientationType.append("5")
                    orientationType.append("6")
                } else if item.contains(kOrientationTypeFamily) {
                    orientationType.append("7")
                }
            }
            dict["orientation"] = orientationType.joined(separator: ",")
        }
        
        if treatmentTypeParam.count > 0 {
            var treatmentType = Array<String>()
            for item in treatmentTypeParam {
                if item.contains(kHandicapTreatmentTypeHearing) {
                    treatmentType.append("1")
                } else if item.contains(kHandicapTreatmentTypeSpeech) {
                    treatmentType.append("2")
                } else if item.contains(kHandicapTreatmentTypeEyesight) {
                    treatmentType.append("3")
                } else if item.contains(kHandicapTreatmentTypeMentalRetardation) {
                    treatmentType.append("4")
                } else if item.contains(kHandicapTreatmentTypePsychicDevelopmentOrAutism) {
                    treatmentType.append("5")
                } else if item.contains(kHandicapTreatmentTypeMovement) {
                    treatmentType.append("6")
                } else if item.contains(kHandicapTreatmentTypeComplexCases) {
                    treatmentType.append("7")
                } else {
                    treatmentType.append("8")
                }
            }
            dict["ovzType"] = treatmentType.joined(separator: ",")
        }
        
        if wellnessTypeParam.count > 0 {
            var wellnessType = Array<String>()
            for item in wellnessTypeParam {
                if item.contains(kWellnessTypeTuberculosis) {
                    wellnessType.append("1")
                } else if item.contains(kWellnessTypeFrequentIllness) {
                    wellnessType.append("2")
                } else {
                    wellnessType.append("3")
                }
            }
            dict["wellness"] = wellnessType.joined(separator: ",")
        }
        
        if workingHoursTypeParam.count > 0 {
            var workingHours = Array<String>()
            for item in workingHoursTypeParam {
                if item.contains(kWorkingHoursTypeShort) {
                    workingHours.append("1")
                } else if item.contains(kWorkingHoursTypeDayShorted) {
                    workingHours.append("2")
                } else if item.contains(kWorkingHoursTypeDayFull) {
                    workingHours.append("3")
                } else if item.contains(kWorkingHoursTypeDayExtended) {
                    workingHours.append("4")
                } else {
                    workingHours.append("5")
                }
            }
            dict["worktime_group"] = workingHours.joined(separator: ",")
        }
        
        if activityTypeParam.count > 0 {
            var activityType = Array<String>()
            for item in activityTypeParam {
                if item.contains(kActivityTypeEducation) {
                    activityType.append("1")
                } else {
                    activityType.append("2")
                }
            }
            dict["activity"] = activityType.joined(separator: ",")
        }
        
        dict["free_space"] = (freeSpace.text?.contains("Да"))! ? "1" : "0"
        
        return dict
    }
    
    // MARK: - Actions
    
    @IBAction func toggleLicence(_ sender: UISwitch) {
        licence.text = sender.isOn ? "Да" : "Нет"
    }
    
    @IBAction func toggleFreeSpace(_ sender: UISwitch) {
        freeSpace.text = sender.isOn ? "Да" : "Не важно"
    }
    
    @IBAction func goToSearchAction(_ sender: UIButton) {
        DataManager.sharedInstance.searchObjects(with: makeDictionaryForSearchRequest())
        NotificationCenter.default.post(name:Notification.Name(rawValue:"FILTER_ENABLED"),
                                        object: nil,
                                        userInfo: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if munId == 0 {
            return 1
        } else {
            return 3
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 4
        } else if section == 2 {
            return 5
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return munId == 0 ? 0.01 : 38.0
        }
        return 38.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        
        switch section {
        case 0:
            headerView.title.text = "Укажите место нахождения"
            break
        case 1:
            headerView.title.text = "Данные по саду"
            break
        case 2:
            headerView.title.text = "Данные по группам"
            break
        default:
            headerView.title.text = ""
            break
        }

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTypes.removeAll()
        if indexPath.section == 0 {
            singleSelectionType = indexPath.row == 0 ? .singleSelectionListRegs : .singleSelectionListMuns
            
            if singleSelectionType == .singleSelectionListRegs || (singleSelectionType == .singleSelectionListMuns && regId > 0) {
                self.performSegue(withIdentifier: "Single Selection List Segue", sender: self)
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                searchKindergartenParamsType = .propertyParamsType
                searchKindergartenParamsSelectionType = .singleParamSelection
                if propertyTypeParam.characters.count > 0 {
                    selectedTypes.append(propertyTypeParam)
                }
                break
            case 1:
                searchKindergartenParamsType = .functionParamsType
                searchKindergartenParamsSelectionType = .singleParamSelection
                if functionTypeParam.characters.count > 0 {
                    selectedTypes.append(functionTypeParam)
                }
                break
            case 2:
                searchKindergartenParamsType = .structureParamsType
                searchKindergartenParamsSelectionType = .multiParamsSelection
                selectedTypes = structureTypeParam
                break
            default:
                break
            }
            if indexPath.row < 3 {
                self.performSegue(withIdentifier: "Search Kindergarten Params Segue", sender: self)
            }
        } else {
            switch indexPath.row {
            case 0:
                let pickerController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchRequestAgePickerViewController") as! SearchRequestAgePickerViewController
                pickerController.pickerDatasource = DataManager.sharedInstance.getAgeRangs()
                pickerController.view.backgroundColor = UIColor.clear
                pickerController.modalPresentationStyle = .overCurrentContext;
                pickerController.providesPresentationContextTransitionStyle = true;
                pickerController.definesPresentationContext = true;
                self.present(pickerController, animated: true, completion: nil)
                break
            case 1:
                searchKindergartenParamsType = .orientationParamsType
                searchKindergartenParamsSelectionType = .multiParamsSelection
                selectedTypes = orientationTypeParam
                break
            case 2:
                searchKindergartenParamsType = .workingHoursParamsType
                searchKindergartenParamsSelectionType = .multiParamsSelection
                selectedTypes = workingHoursTypeParam
                break
            case 3:
                searchKindergartenParamsType = .activityParamsType
                searchKindergartenParamsSelectionType = .multiParamsSelection
                selectedTypes = activityTypeParam
                break
            default:
                break
            }
            if indexPath.row > 0 &&  indexPath.row < 4 {
                self.performSegue(withIdentifier: "Search Kindergarten Params Segue", sender: self)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search Kindergarten Params Segue" {
            if let viewController = segue.destination as? SearchKindergartenParamsViewController {
                viewController.searchKindergartenParamsType = searchKindergartenParamsType
                viewController.searchKindergartenParamsSelectionType = searchKindergartenParamsSelectionType
                viewController.datasource = DataManager.sharedInstance.getParamsList(by: searchKindergartenParamsType)!
                viewController.selectedTypes = selectedTypes
                viewController.selectedTreatmentTypes = treatmentTypeParam
                viewController.selectedWellnessTypes = wellnessTypeParam
            }
        } else if segue.identifier == "Single Selection List Segue" {
            if let viewController = segue.destination as? SingleSelectionListViewController {
                let param = singleSelectionType == .singleSelectionListRegs ? "" : "\(regId)"
                viewController.viewModel = SingleSelectionListViewModel(type: singleSelectionType, params: param)
            }
        }
    }
    
}
