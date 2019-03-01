//
//  CustomSearchBar.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 21/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        showsCancelButton = false
        let image = UIImage()
        setBackgroundImage(image, for: .any, barMetrics: .default)
        scopeBarBackgroundImage = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
