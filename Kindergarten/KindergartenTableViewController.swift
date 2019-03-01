//
//  KindergartenTableViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 07/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class KindergartenTableViewController: UITableViewController {

    var viewmodel: KindergartenViewModel?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var kindergartenName: UILabel!
    @IBOutlet weak var kindergartenWorkingHours: UILabel!
    
    @IBOutlet weak var kindergartenType: UILabel!
    @IBOutlet weak var kindergartenStatus: UILabel!
    @IBOutlet weak var kindergartenStructure: UILabel!
    @IBOutlet weak var kindergartenLicense: UILabel!
    @IBOutlet weak var kindergartenNumberOfGroups: UILabel!
    @IBOutlet weak var kindergartenFeatures: UILabel!
    @IBOutlet weak var kindergartenAdditionalEducation: UILabel!
    
    @IBOutlet weak var kindergartenAddress: UILabel!
    @IBOutlet weak var kindergartenPhone: UILabel!
    @IBOutlet weak var kindergartenEmail: UILabel!
    @IBOutlet weak var kindergartenWebsite: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    @IBOutlet weak var kindergartenNumberOfKids: UILabel!
    @IBOutlet weak var kindergartenPriorityNeeded: UILabel!
    @IBOutlet weak var kindergartenWaitingTime: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"REGMUN_OK"),
                                               object:nil, queue:nil) { [weak self] notification in
                                                guard let strongSelf = self else {
                                                    return
                                                }
                                                strongSelf.loadingIndicator.stopAnimating()
                                                strongSelf.performSegue(withIdentifier: "Enroll Kindergarten Segue", sender: self)
                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: {
                                                    NotificationCenter.default.post(name:Notification.Name(rawValue:"REGMUN_DID_LOAD"),
                                                                                    object: nil,
                                                                                    userInfo:notification.userInfo)
                                                })
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
        if viewmodel?.kindergarten != nil {
            kindergartenName.text = viewmodel?.kindergarten?.name
            kindergartenName.sizeToFit()
            kindergartenWorkingHours.text = "Время работы: \((viewmodel?.kindergarten?.workingHours)!)"
            kindergartenWorkingHours.sizeToFit()
            headerView.bounds.size.height = kindergartenName.frame.size.height + kindergartenWorkingHours.frame.size.height + 30.0
            
            kindergartenType.text = viewmodel?.kindergarten?.propertyType.description
            kindergartenStatus.text = viewmodel?.kindergarten?.functionStatus.description
            kindergartenStructure.text = viewmodel?.kindergarten?.structureType.description
            kindergartenLicense.text = (viewmodel?.kindergarten?.isLicensed)! ? "С лицензией" : "Без лицензии"
            kindergartenNumberOfGroups.text = "\((viewmodel?.kindergarten?.numberOfGroups)!)"
            kindergartenFeatures.text = viewmodel?.kindergarten?.feature
            kindergartenFeatures.sizeToFit()
            kindergartenAdditionalEducation.text = viewmodel?.kindergarten?.additionalEducation
            kindergartenAdditionalEducation.sizeToFit()
            
            kindergartenAddress.text = viewmodel?.kindergarten?.legalAddress
            
            phoneButton.isHidden = (viewmodel?.kindergarten?.phone.characters.count)! < 1 || (viewmodel?.kindergarten?.phone.contains("нет"))!
            kindergartenPhone.text = phoneButton.isHidden ? "Нет данных" : viewmodel?.kindergarten?.phone
            
            emailButton.isHidden = (viewmodel?.kindergarten?.email.characters.count)! < 1 || (viewmodel?.kindergarten?.email.contains("нет"))!
            kindergartenEmail.text = emailButton.isHidden ? "Нет данных" : viewmodel?.kindergarten?.email
            
            websiteButton.isHidden = (viewmodel?.kindergarten?.webSite.characters.count)! < 1 || (viewmodel?.kindergarten?.webSite.contains("http"))!
            kindergartenWebsite.text = websiteButton.isHidden ? "Нет данных" : viewmodel?.kindergarten?.webSite
            
            kindergartenNumberOfKids.text = "\((viewmodel?.kindergarten?.numberOfKids.total)!) чел."
            kindergartenPriorityNeeded.text = "\((viewmodel?.kindergarten?.priorityNeedsForCurrentYear.total)!) чел."
            kindergartenWaitingTime.text =  (viewmodel?.kindergarten?.commonWaitingTime.total)! > 0 ? "\((viewmodel?.kindergarten?.commonWaitingTime.total)!)" : "Нет групп"
            

            favoriteButton.isSelected = DataManager.sharedInstance.isFavorite(kindergartenId: (viewmodel?.kindergarten?.id)!)
            
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Actions
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        DataManager.sharedInstance.updateFavorites(kindergartenId: (viewmodel?.kindergarten?.id)!, remove: !sender.isSelected)
    }
    
    @IBAction func makeCall(_ sender: Any) {
        if (kindergartenPhone.text?.characters.count)! > 0 {
            DataManager.sharedInstance.makeCall(to: kindergartenPhone.text!)
        }
    }
    
    @IBAction func goToWebsite(_ sender: Any) {
        if (kindergartenWebsite.text?.characters.count)! > 0 {
            DataManager.sharedInstance.openWebsite(with: kindergartenWebsite.text!)
        }
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if (kindergartenEmail.text?.characters.count)! > 0 {
            DataManager.sharedInstance.sendEmail(to: kindergartenEmail.text!)
        }
    }

    @IBAction func enrollKindergartenAction(_ sender: Any) {
        DataManager.sharedInstance.getRegMun(by: (viewmodel?.kindergarten?.munId)!)
        loadingIndicator.startAnimating()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableView.tag == 1 ? 4 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            if section == 0 {
                return 7
            } else if section == 1 {
                return 4
            } else if section == 2 {
                return 3
            } else if section == 3 {
                return 1
            }
        } else {
            return (self.viewmodel?.kindergarten?.buildings?.count)!
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = super.tableView(tableView, cellForRowAt: indexPath);
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingShortInfoCell", for: indexPath as IndexPath) as? BuildingShortInfoTableViewCell else {
                return UITableViewCell()
            }
            
            let building = self.viewmodel?.kindergarten?.buildings?[indexPath.row]
            
            cell.buildingName.text = building?.buildingName
            cell.buildingAddress.text = building?.address
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        
        switch section {
        case 0:
            headerView.title.text = "Общие сведения"
            break
        case 1:
            headerView.title.text = "Контакты"
            break
        case 2:
            headerView.title.text = "Основные показатели"
            break
        case 3:
            headerView.title.text = "Детальная информация"
            break
        default:
            headerView.title.text = ""
            break
        }
        
        return headerView
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NumberOfKids Segue" {
            if let viewController = segue.destination as? NumberOfKidsTableViewController {
                viewController.datasource = viewmodel?.kindergarten?.numberOfKids
            }
        }
        if segue.identifier == "PriorityNeeded Segue" {
            if let viewController = segue.destination as? PriorityNeededTableViewController {
                viewController.datasourceCurrent = viewmodel?.kindergarten?.priorityNeedsForCurrentYear
                viewController.datasourceNext = viewmodel?.kindergarten?.priorityNeedsForNextYear
            }
        }
        if segue.identifier == "WaitingTime Segue" {
            if let viewController = segue.destination as? WaitingTimeTableViewController {
                viewController.datasourceAge = viewmodel?.kindergarten?.nonPrivelegedWaitingTime
                viewController.datasourcePrivileges = viewmodel?.kindergarten?.privelegedWaitingTime
            }
        }
    }

}
