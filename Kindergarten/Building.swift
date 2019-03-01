//
//  Building.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 07.08.17.
//  Copyright © 2017 Informika. All rights reserved.
//

import Foundation

struct Building {
    var buildingId: String
    var buildingName: String
    var institutionId: String
    var address: String
    var groups: Array<Group>?
}
