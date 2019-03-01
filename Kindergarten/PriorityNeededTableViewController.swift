//
//  PriorityNeededTableViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 03/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class PriorityNeededTableViewController: UITableViewController {

    @IBOutlet weak var currentTotal: UILabel!
    @IBOutlet weak var current021: UILabel!
    @IBOutlet weak var current12: UILabel!
    @IBOutlet weak var current23: UILabel!
    @IBOutlet weak var current34: UILabel!
    @IBOutlet weak var current45: UILabel!
    @IBOutlet weak var current56: UILabel!
    @IBOutlet weak var current67: UILabel!
    @IBOutlet weak var currentUpTo7: UILabel!
    
    @IBOutlet weak var nextTotal: UILabel!
    @IBOutlet weak var next021: UILabel!
    @IBOutlet weak var next12: UILabel!
    @IBOutlet weak var next23: UILabel!
    @IBOutlet weak var next34: UILabel!
    @IBOutlet weak var next45: UILabel!
    @IBOutlet weak var next56: UILabel!
    @IBOutlet weak var next67: UILabel!
    @IBOutlet weak var nextUpTo7: UILabel!
    
    var datasourceCurrent: KindergartenSummary?
    var datasourceNext: KindergartenSummary?
    
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
        
        currentTotal.text = "\((datasourceCurrent?.total)!) чел."
        current021.text = "\((datasourceCurrent?.twoMonthsToOneYear)!) чел."
        current12.text = "\((datasourceCurrent?.oneYearToTwoYears)!) чел."
        current23.text = "\((datasourceCurrent?.twoYearsToThreeYears)!) чел."
        current34.text = "\((datasourceCurrent?.threeYearsToFourYears)!) чел."
        current45.text = "\((datasourceCurrent?.fourYearsToFiveYears)!) чел."
        current56.text = "\((datasourceCurrent?.fiveYearsToSixYears)!) чел."
        current67.text = "\((datasourceCurrent?.sixYearsToSevenYears)!) чел."
        currentUpTo7.text = "\((datasourceCurrent?.sevenYearsAndUp)!) чел."
        
        nextTotal.text = "\((datasourceNext?.total)!) чел."
        next021.text = "\((datasourceNext?.twoMonthsToOneYear)!) чел."
        next12.text = "\((datasourceNext?.oneYearToTwoYears)!) чел."
        next23.text = "\((datasourceNext?.twoYearsToThreeYears)!) чел."
        next34.text = "\((datasourceNext?.threeYearsToFourYears)!) чел."
        next45.text = "\((datasourceNext?.fourYearsToFiveYears)!) чел."
        next56.text = "\((datasourceNext?.fiveYearsToSixYears)!) чел."
        next67.text = "\((datasourceNext?.sixYearsToSevenYears)!) чел."
        nextUpTo7.text = "\((datasourceNext?.sevenYearsAndUp)!) чел."
    }
    
    func handleHint1() {
        DataManager.sharedInstance.showHint(for: "Приоритетная потребность на текущий год")
    }
    
    func handleHint2() {
        DataManager.sharedInstance.showHint(for: "Приоритетная потребность на следующий год")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
            headerView.title.text = "Приоритетная потребность на текущий год"
            headerView.hintButton.isHidden = false
            headerView.hintButton.addTarget(self, action: #selector(handleHint1), for: .touchUpInside)
            break
        case 1:
            headerView.title.text = "Приоритетная потребность на следующий год"
            headerView.hintButton.isHidden = false
            headerView.hintButton.addTarget(self, action: #selector(handleHint2), for: .touchUpInside)
            break
        default:
            headerView.title.text = ""
            break
        }
        
        return headerView
    }
    
}
