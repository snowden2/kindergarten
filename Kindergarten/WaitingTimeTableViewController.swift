//
//  WaitingTimeTableViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 03/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class WaitingTimeTableViewController: UITableViewController {

    @IBOutlet weak var ageTotal: UILabel!
    @IBOutlet weak var age021: UILabel!
    @IBOutlet weak var age12: UILabel!
    @IBOutlet weak var age23: UILabel!
    @IBOutlet weak var age34: UILabel!
    @IBOutlet weak var age45: UILabel!
    @IBOutlet weak var age56: UILabel!
    @IBOutlet weak var age67: UILabel!
    @IBOutlet weak var ageUpTo7: UILabel!

    @IBOutlet weak var privilegesTotal: UILabel!
    @IBOutlet weak var privileges021: UILabel!
    @IBOutlet weak var privileges12: UILabel!
    @IBOutlet weak var privileges23: UILabel!
    @IBOutlet weak var privileges34: UILabel!
    @IBOutlet weak var privileges45: UILabel!
    @IBOutlet weak var privileges56: UILabel!
    @IBOutlet weak var privileges67: UILabel!
    @IBOutlet weak var privilegesUpTo7: UILabel!
    
    var datasourceAge: KindergartenSummary?
    var datasourcePrivileges: KindergartenSummary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CustomHeaderView")
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        
        /*ageTotal.text = "\((datasourceAge?.total)!)"
        age021.text = "\((datasourceAge?.twoMonthsToOneYear)!)"
        age12.text = "\((datasourceAge?.oneYearToTwoYears)!)"
        age23.text = "\((datasourceAge?.twoYearsToThreeYears)!)"
        age34.text = "\((datasourceAge?.threeYearsToFourYears)!)"
        age45.text = "\((datasourceAge?.fourYearsToFiveYears)!)"
        age56.text = "\((datasourceAge?.fiveYearsToSixYears)!)"
        age67.text = "\((datasourceAge?.sixYearsToSevenYears)!)"
        ageUpTo7.text = "\((datasourceAge?.sevenYearsAndUp)!)"
        
        privilegesTotal.text = "\((datasourcePrivileges?.total)!)"
        privileges021.text = "\((datasourcePrivileges?.twoMonthsToOneYear)!)"
        privileges12.text = "\((datasourcePrivileges?.oneYearToTwoYears)!)"
        privileges23.text = "\((datasourcePrivileges?.twoYearsToThreeYears)!)"
        privileges34.text = "\((datasourcePrivileges?.threeYearsToFourYears)!)"
        privileges45.text = "\((datasourcePrivileges?.fourYearsToFiveYears)!)"
        privileges56.text = "\((datasourcePrivileges?.fiveYearsToSixYears)!)"
        privileges67.text = "\((datasourcePrivileges?.sixYearsToSevenYears)!)"
        privilegesUpTo7.text = "\((datasourcePrivileges?.sevenYearsAndUp)!)"*/
    }
    
    func handleHint1() {
        DataManager.sharedInstance.showHint(for: "Среднее время ожидания места")
    }
    
    func handleHint2() {
        DataManager.sharedInstance.showHint(for: "Среднее время ожидания места для детей без льгот")
    }
    
    func handleHint3() {
        DataManager.sharedInstance.showHint(for: "Среднее время ожидания места для детей, имеющих льготы")
    }
    
    func handleHint4() {
        DataManager.sharedInstance.showHint(for: "Среднее время ожидания места для детей с ОВЗ")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        
        headerView.hintButton.removeTarget(nil, action: nil, for: .allEvents)
        
        switch section {
        case 0:
            headerView.title.text = "Среднее время ожидания места"
            headerView.hintButton.isHidden = false
            headerView.hintButton.addTarget(self, action: #selector(handleHint1), for: .touchUpInside)
            break
        case 1:
            headerView.title.text = "Среднее время ожидания места для детей без льгот"
            headerView.hintButton.isHidden = false
            headerView.hintButton.addTarget(self, action: #selector(handleHint2), for: .touchUpInside)
            break
        case 2:
            headerView.title.text = "Среднее время ожидания места для детей, имеющих льготы"
            headerView.hintButton.isHidden = false
            headerView.hintButton.addTarget(self, action: #selector(handleHint3), for: .touchUpInside)
            break
        case 3:
            headerView.title.text = "Среднее время ожидания места для детей с ОВЗ"
            headerView.hintButton.isHidden = false
            headerView.hintButton.addTarget(self, action: #selector(handleHint4), for: .touchUpInside)
            break
        default:
            headerView.title.text = ""
            break
        }
        
        return headerView
    }
    
}
