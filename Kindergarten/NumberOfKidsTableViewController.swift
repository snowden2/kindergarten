//
//  NumberOfKidsTableViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 03/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class NumberOfKidsTableViewController: UITableViewController {

    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var fromTwoMonthToOneYear: UILabel!
    @IBOutlet weak var fromOneToTwoYear: UILabel!
    @IBOutlet weak var fromTwoToThreeYear: UILabel!
    @IBOutlet weak var fromThreeToFourYear: UILabel!
    @IBOutlet weak var fromFourToFiveYear: UILabel!
    @IBOutlet weak var fromFiveToSixYear: UILabel!
    @IBOutlet weak var fromSixToSevenYear: UILabel!
    @IBOutlet weak var upToSevenYear: UILabel!
    
    var datasource: KindergartenSummary?
    
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
        total.text = "\((datasource?.total)!) чел."
        fromTwoMonthToOneYear.text = "\((datasource?.twoMonthsToOneYear)!) чел."
        fromOneToTwoYear.text = "\((datasource?.oneYearToTwoYears)!) чел."
        fromTwoToThreeYear.text = "\((datasource?.twoYearsToThreeYears)!) чел."
        fromThreeToFourYear.text = "\((datasource?.threeYearsToFourYears)!) чел."
        fromFourToFiveYear.text = "\((datasource?.fourYearsToFiveYears)!) чел."
        fromFiveToSixYear.text = "\((datasource?.fiveYearsToSixYears)!) чел."
        fromSixToSevenYear.text = "\((datasource?.sixYearsToSevenYears)!) чел."
        upToSevenYear.text = "\((datasource?.sevenYearsAndUp)!) чел."
    }

    @IBAction func showHint(_ sender: Any) {
        DataManager.sharedInstance.showHint(for: "Общее число детей")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath);
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomHeaderView") as! CustomHeaderView
        
        switch section {
        case 0:
            headerView.title.text = "Общее число детей"
            break
        default:
            headerView.title.text = ""
            break
        }
        
        return headerView
    }
    
}
