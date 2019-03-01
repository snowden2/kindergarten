//
//  SingleSelectionParamsTableViewCell.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 11/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class SingleSelectionParamsTableViewCell: UITableViewCell {

    @IBOutlet weak private var selectionIndicator: UIImageView!
    @IBOutlet weak private var paramLabel: UILabel!
    @IBOutlet weak private var selectionInfo: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    private var isDisclosurable = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //if !isDisclosurable {
        //    selectionIndicator.image = selected ? UIImage(named: "Select") : UIImage(named: "SelectNone")
        //}
    }
    
    func switchSelectionIndicator(to select: Bool, andUpdateSelectedInfo info: String) {
        DispatchQueue.main.async {
            self.selectionIndicator.image = select ? UIImage(named: "Select") : UIImage(named: "SelectNone")
            if info.characters.count > 0 {
                self.selectionInfo.text = info
            }
        }
    }
    
    func configCell(param: String, isDisclosurable: Bool) {
        paramLabel.text = param
        selectionInfo.isHidden = !isDisclosurable
        infoButton.isHidden = isDisclosurable || (param != kOrientationTypeCommon && param != kOrientationTypeWelness && param != kOrientationTypeHandicap && param != kOrientationTypeCare && param != kOrientationTypeFamily && param != kActivityTypeCare && param != kActivityTypeEducation)
        self.accessoryType = isDisclosurable ? .disclosureIndicator : .none
        self.isDisclosurable = isDisclosurable
    }
    
    @IBAction func showHint(_ sender: Any) {
        DataManager.sharedInstance.showHint(for: paramLabel.text!)
    }
    
}
