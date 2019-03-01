//
//  CustomPinAnnotationView.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 06/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

class CustomPinAnnotationView: YMKPinAnnotationView {

    override func setSelected(_ selected: Bool, animated: Bool) {
        if (self.annotation as! PointAnnotation).type > 0 {
            super.setSelected(selected, animated: false)
            
            let nc = NotificationCenter.default
            
            if selected {
                nc.post(name:Notification.Name(rawValue:"SHOW_CALLOUT_VIEW"),
                        object: nil,
                        userInfo: ["annotation":self.annotation])
            } else {
                nc.post(name:Notification.Name(rawValue:"HIDE_CALLOUT_VIEW"),
                        object: nil,
                        userInfo: ["annotation":self.annotation])
            }
        } else {
            NotificationCenter.default.post(name:Notification.Name(rawValue:"ZOOM_IN"),
                    object: nil,
                    userInfo: ["annotation":self.annotation])
        }
    }
    
}
