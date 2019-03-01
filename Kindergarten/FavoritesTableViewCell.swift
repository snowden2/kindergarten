//
//  FavoritesTableViewCell.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 22/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var removeFromFavorites: UILabel!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var id: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func removeFromFavorites(_ sender: Any) {
        NotificationCenter.default.post(name:Notification.Name(rawValue:"REMOVE_FAVORITE_REQUEST"),
                object: nil,
                userInfo: ["id":id!])
    }
    
}
