//
//  EnrollKindergartenTableViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 26/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class EnrollKindergartenTableViewController: UITableViewController {

    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var minicipality: UILabel!
    
    @IBOutlet weak var providerName: UILabel!
    @IBOutlet weak var providerAddress: UILabel!
    
    @IBOutlet weak var providerPhone: UILabel!
    @IBOutlet weak var providerPhone2: UILabel!
    @IBOutlet weak var providerPhone3: UILabel!
    @IBOutlet weak var providerPhone4: UILabel!
    @IBOutlet weak var providerPhone5: UILabel!
    @IBOutlet weak var providerPhone6: UILabel!
    @IBOutlet weak var providerPhone7: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    @IBOutlet weak var providerEmail: UILabel!
    @IBOutlet weak var providerWebsite: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    @IBOutlet weak var preSchoolProvidedTotal: UILabel!
    @IBOutlet weak var preSchoolProvidedThreeToSeven: UILabel!
    
    @IBOutlet weak var preSchoolUnprovidedTotal: UILabel!
    @IBOutlet weak var preSchoolUnprovidedOneAndHalfToThree: UILabel!
    @IBOutlet weak var preSchoolUnprovidedThreeToSeven: UILabel!
    
    @IBOutlet weak var orderLinkButton: UIButton!
    @IBOutlet weak var orderLinkBtn: UIButton!
    @IBOutlet weak var areaDocumentLinkButton: UIButton!
    @IBOutlet weak var areaDocumentLinkBtn: UIButton!
    
    @IBOutlet weak var rpguLinkButton: UIButton!
    @IBOutlet weak var rpguLinkBtn: UIButton!
    
    @IBOutlet weak var epguLinkButton: UIButton!
    @IBOutlet weak var epguLinkBtn: UIButton!
    
    var singleSelectionType = SingleSelectionListType.singleSelectionListRegs
    var regId = 45
    var rpguLink: String?
    var epguLink: String?
    var areaDocumentLink: String?
    var orderLink: String?
    var phonesCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        var disabledAttributedTitle = NSAttributedString(string: "На региональном портале", attributes: [NSForegroundColorAttributeName : UIColor.black, NSParagraphStyleAttributeName: style])
        rpguLinkButton.setAttributedTitle(disabledAttributedTitle, for: .disabled)
        var normalAttributedTitle = NSAttributedString(string: "На региональном портале", attributes: [NSForegroundColorAttributeName : UIColor(red: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), NSParagraphStyleAttributeName: style])
        rpguLinkButton.setAttributedTitle(normalAttributedTitle, for: .normal)
        
        disabledAttributedTitle = NSAttributedString(string: "На федеральном портале", attributes: [NSForegroundColorAttributeName : UIColor.black, NSParagraphStyleAttributeName: style])
        epguLinkButton.setAttributedTitle(disabledAttributedTitle, for: .disabled)
        normalAttributedTitle = NSAttributedString(string: "На федеральном портале", attributes: [NSForegroundColorAttributeName : UIColor(red: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), NSParagraphStyleAttributeName: style])
        epguLinkButton.setAttributedTitle(normalAttributedTitle, for: .normal)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"REGS_DID_SELECT"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.regId = notification.userInfo?["regId"] as! Int
                        strongSelf.region.text = notification.userInfo?["regName"] as? String
                        
                        strongSelf.tableView.reloadData()
        }
        nc.addObserver(forName:Notification.Name(rawValue:"MUNS_DID_SELECT"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        let municipality = notification.userInfo?["municipality"] as! Municipality
                        strongSelf.minicipality.text = municipality.name
                        strongSelf.providerName.text = municipality.providerName
                        strongSelf.providerAddress.text = municipality.providerAddress
                        
                        strongSelf.phoneButton.isHidden = municipality.mainPhone.contains("нет")
                        if strongSelf.phoneButton.isHidden {
                            strongSelf.providerPhone.text = "Нет данных"
                        } else {
                            strongSelf.processPhones(phones: municipality.mainPhone)
                        }
                        
                        strongSelf.emailButton.isHidden = municipality.email.contains("нет")
                        strongSelf.providerEmail.text = strongSelf.emailButton.isHidden ? "Нет данных" : municipality.email
                        
                        strongSelf.websiteButton.isHidden = !municipality.website.contains("http")
                        strongSelf.providerWebsite.text = strongSelf.websiteButton.isHidden ? "Нет данных" : municipality.website
                        
                        strongSelf.preSchoolProvidedTotal.text = "\(String(format: "%.02f", municipality.preSchoolProvidedTotal))%"
                        strongSelf.preSchoolProvidedThreeToSeven.text = "\(String(format: "%.02f", municipality.preSchoolProvidedThreeToSeven))%"
                        strongSelf.preSchoolUnprovidedTotal.text = "\(Int(municipality.preSchoolUnprovidedTotal)) чел."
                        strongSelf.preSchoolUnprovidedOneAndHalfToThree.text = "\(Int(municipality.preSchoolUnprovidedOneAndHalfToThree)) чел."
                        strongSelf.preSchoolUnprovidedThreeToSeven.text = "\(Int(municipality.preSchoolUnprovidedThreeToSeven)) чел."
                        strongSelf.rpguLink = municipality.regionalPortalUrl
                        strongSelf.epguLink = municipality.federalPortalUrl
                        strongSelf.areaDocumentLink = municipality.areaDocumentUrl
                        strongSelf.orderLink = municipality.orderUrl
                        
                        strongSelf.orderLinkBtn.isEnabled = (strongSelf.orderLink?.contains("http"))!
                        strongSelf.orderLinkBtn.setTitleColor(strongSelf.orderLinkBtn.isEnabled ? UIColor(red: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) : .black, for: .disabled)
                        strongSelf.orderLinkButton.isHidden = !strongSelf.orderLinkBtn.isEnabled
                        
                        strongSelf.areaDocumentLinkBtn.isEnabled = (strongSelf.areaDocumentLink?.contains("http"))!
                        strongSelf.areaDocumentLinkBtn.setTitleColor(strongSelf.areaDocumentLinkBtn.isEnabled ? UIColor(red: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) : .black, for: .disabled)
                        strongSelf.areaDocumentLinkButton.isHidden = !strongSelf.areaDocumentLinkBtn.isEnabled
                        
                        strongSelf.rpguLinkBtn.isEnabled = (strongSelf.rpguLink?.contains("http"))!
                        strongSelf.rpguLinkButton.isEnabled = strongSelf.rpguLinkBtn.isEnabled
                        
                        strongSelf.epguLinkBtn.isEnabled = (strongSelf.epguLink?.contains("http"))!
                        strongSelf.epguLinkButton.isEnabled = strongSelf.epguLinkBtn.isEnabled
                        
                        strongSelf.tableView.beginUpdates()
                        strongSelf.tableView.endUpdates()
        }
        nc.addObserver(forName:Notification.Name(rawValue:"REGMUN_DID_LOAD"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.regId = notification.userInfo?["regId"] as! Int
                        strongSelf.region.text = notification.userInfo?["regName"] as? String
                        
                        let municipality = notification.userInfo?["municipality"] as! Municipality
                        strongSelf.minicipality.text = municipality.name
                        strongSelf.providerName.text = municipality.providerName
                        strongSelf.providerName.sizeToFit()
                        strongSelf.providerAddress.text = municipality.providerAddress
                        strongSelf.providerAddress.sizeToFit()
                        
                        strongSelf.phoneButton.isHidden = municipality.mainPhone.contains("нет")
                        if strongSelf.phoneButton.isHidden {
                            strongSelf.providerPhone.text = "Нет данных"
                        } else {
                            strongSelf.processPhones(phones: municipality.mainPhone)
                        }
                        
                        strongSelf.emailButton.isHidden = municipality.email.contains("нет")
                        strongSelf.providerEmail.text = strongSelf.emailButton.isHidden ? "Нет данных" : municipality.email
                        
                        strongSelf.websiteButton.isHidden = !municipality.website.contains("http")
                        strongSelf.providerWebsite.text = strongSelf.websiteButton.isHidden ? "Нет данных" : municipality.website
                        
                        strongSelf.preSchoolProvidedTotal.text = "\(String(format: "%.02f", municipality.preSchoolProvidedTotal))%"
                        strongSelf.preSchoolProvidedThreeToSeven.text = "\(String(format: "%.02f", municipality.preSchoolProvidedThreeToSeven))%"
                        strongSelf.preSchoolUnprovidedTotal.text = "\(Int(municipality.preSchoolUnprovidedTotal)) чел."
                        strongSelf.preSchoolUnprovidedOneAndHalfToThree.text = "\(Int(municipality.preSchoolUnprovidedOneAndHalfToThree)) чел."
                        strongSelf.preSchoolUnprovidedThreeToSeven.text = "\(Int(municipality.preSchoolUnprovidedThreeToSeven)) чел."
                        strongSelf.rpguLink = municipality.regionalPortalUrl
                        strongSelf.epguLink = municipality.federalPortalUrl
                        strongSelf.areaDocumentLink = municipality.areaDocumentUrl
                        strongSelf.orderLink = municipality.orderUrl
                        
                        strongSelf.orderLinkBtn.isEnabled = (strongSelf.orderLink?.contains("http"))!
                        strongSelf.orderLinkBtn.setTitleColor(strongSelf.orderLinkBtn.isEnabled ? UIColor(red: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) : .black, for: .disabled)
                        strongSelf.orderLinkButton.isHidden = !strongSelf.orderLinkBtn.isEnabled
                        
                        strongSelf.areaDocumentLinkBtn.isEnabled = (strongSelf.areaDocumentLink?.contains("http"))!
                        strongSelf.areaDocumentLinkBtn.setTitleColor(strongSelf.areaDocumentLinkBtn.isEnabled ? UIColor(red: 0, green: 122.0/255.0, blue: 1.0, alpha: 1.0) : .black, for: .disabled)
                        strongSelf.areaDocumentLinkButton.isHidden = !strongSelf.areaDocumentLinkBtn.isEnabled
                        
                        strongSelf.rpguLinkBtn.isEnabled = (strongSelf.rpguLink?.contains("http"))!
                        strongSelf.rpguLinkButton.isEnabled = strongSelf.rpguLinkBtn.isEnabled
                        
                        strongSelf.epguLinkBtn.isEnabled = (strongSelf.epguLink?.contains("http"))!
                        strongSelf.epguLinkButton.isEnabled = strongSelf.epguLinkBtn.isEnabled
                        
                        strongSelf.tableView.reloadData()
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func processPhones(phones: String) {
        if phones.contains(",") {
            let phonesComp = phones.components(separatedBy: ",")
            phonesCount = phonesComp.count
            for i in 0..<phonesComp.count {
                switch i {
                case 0:
                    providerPhone.text = DataManager.sharedInstance.transformPhone(phone: phonesComp[i])
                    break
                case 1:
                    providerPhone2.text = DataManager.sharedInstance.transformPhone(phone: phonesComp[i])
                    break
                case 2:
                    providerPhone3.text = DataManager.sharedInstance.transformPhone(phone: phonesComp[i])
                    break
                case 3:
                    providerPhone4.text = DataManager.sharedInstance.transformPhone(phone: phonesComp[i])
                    break
                case 4:
                    providerPhone5.text = DataManager.sharedInstance.transformPhone(phone: phonesComp[i])
                    break
                case 5:
                    providerPhone6.text = DataManager.sharedInstance.transformPhone(phone: phonesComp[i])
                    break
                case 6:
                    providerPhone7.text = DataManager.sharedInstance.transformPhone(phone: phonesComp[i])
                    break
                default:
                    break
                }
            }
        } else {
            providerPhone.text = DataManager.sharedInstance.transformPhone(phone: phones)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func makeCallMainPhone(_ sender: Any) {
        if (providerPhone.text?.characters.count)! > 0 {
            DataManager.sharedInstance.makeCall(to: providerPhone.text!)
        }
    }
    
    @IBAction func sendEmail(_ sender: Any) {
        if (providerEmail.text?.characters.count)! > 0 {
            DataManager.sharedInstance.sendEmail(to: providerEmail.text!)
        }
    }
    
    @IBAction func openWebsite(_ sender: Any) {
        if (providerWebsite.text?.characters.count)! > 0 {
            DataManager.sharedInstance.openWebsite(with: providerWebsite.text!)
        }
    }
    
    @IBAction func openRPGU(_ sender: Any) {
        if (rpguLink?.characters.count)! > 0 {
            DataManager.sharedInstance.openWebsite(with: rpguLink!)
        }
    }
    
    @IBAction func openEPGU(_ sender: Any) {
        if (epguLink?.characters.count)! > 0 {
            DataManager.sharedInstance.openWebsite(with: epguLink!)
        }
    }
    
    @IBAction func openOrderLink(_ sender: Any) {
        if (orderLink?.characters.count)! > 0 {
            DataManager.sharedInstance.openWebsite(with: orderLink!)
        }
    }
    
    @IBAction func openAreaDocumentLink(_ sender: Any) {
        if (areaDocumentLink?.characters.count)! > 0 {
            DataManager.sharedInstance.openWebsite(with: areaDocumentLink!)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 4
        } else if section == 2 {
            return 2
        } else if section == 3 {
            return 1
        } else if section == 4 {
            return 2
        } else if section == 5 {
            return 3
        }  else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            singleSelectionType = indexPath.row == 0 ? .singleSelectionListRegs : .singleSelectionListMuns
            
            if singleSelectionType == .singleSelectionListRegs || (singleSelectionType == .singleSelectionListMuns && regId > 0) {
                self.performSegue(withIdentifier: "Single Selection List Segue", sender: self)
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            return providerName.frame.size.height + providerAddress.frame.size.height + 80
        } else if indexPath.section == 1 && indexPath.row == 1 {
            return CGFloat(Double(phonesCount) * 35.0)
        } else if indexPath.section == 3 && indexPath.row == 0 {
            return 140.0
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 65.0
        } else {
            return 50.0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        
        switch section {
        case 0:
            headerView.title.text = "Укажите место проживания"
            break
        case 1:
            headerView.title.text = "Орган управления образования, ответственный за оказание услуги по постановке на очередь"
            break
        case 2:
            headerView.title.text = "Нормативные документы по постановке на очередь"
            break
        case 3:
            headerView.title.text = "Подать заявку:"
            break
        case 4:
            headerView.title.text = "Обеспеченность дошкольным образованием"
            break
        case 5:
            headerView.title.text = "Число детей, не обеспеченных дошкольным образованием"
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
        if segue.identifier == "Single Selection List Segue" {
            if let viewController = segue.destination as? SingleSelectionListViewController {
                let param = singleSelectionType == .singleSelectionListRegs ? "" : "\(regId)"
                viewController.viewModel = SingleSelectionListViewModel(type: singleSelectionType, params: param)
            }
        }
    }

}
