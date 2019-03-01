//
//  PointAnnotation.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 17/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit
import MapKit

class PointAnnotation: NSObject, YMKDraggableAnnotation {
    var organizationId: String
    var name: String
    var type: Int
    var status: Int
    var phone: String
    var address: String
    var coords: YMKMapCoordinate
    var clusterAnnotaions: Array<PointAnnotation>?
    
    required init(organizationId: String, name: String, type: Int, status: Int, phone: String, address: String, coords: YMKMapCoordinate, clusterAnnotaions: Array<PointAnnotation>?) {
        //super.init()
        self.organizationId = organizationId
        self.name = name
        self.type = type
        self.status = status
        self.phone = phone
        self.address = address
        self.coords = coords
        self.clusterAnnotaions = clusterAnnotaions
    }
    
    func setCoordinate(_ coordinate: YMKMapCoordinate) {
        coords = coordinate
    }
    
    func coordinate() -> YMKMapCoordinate {
        return coords
    }
}
