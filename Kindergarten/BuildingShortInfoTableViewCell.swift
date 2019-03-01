//
//  BuildingShortInfoTableViewCell.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 19/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class BuildingShortInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var buildingName: UILabel!
    @IBOutlet weak var buildingAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
