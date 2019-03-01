//
//  KindergartenViewModel.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 15/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

protocol KindergartenViewModelProtocol: class {
    var kindergarten: Kindergarten? { get set }
}

class KindergartenViewModel: KindergartenViewModelProtocol {
    var kindergarten: Kindergarten?

    required init(kindergarten: Kindergarten) {
        self.kindergarten = kindergarten
    }
}
