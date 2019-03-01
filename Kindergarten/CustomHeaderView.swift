//
//  CustomHeaderView.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 06/10/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var title: UILabel! {
        didSet {
            self.contentView.backgroundColor = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
            title.sizeToFit()
        }
    }
    
    @IBOutlet weak var hintButton: UIButton!
    
}
