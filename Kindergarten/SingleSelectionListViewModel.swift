//
//  SingleSelectionListViewModel.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 29/09/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit

protocol SingleSelectionListViewModelProtocol: class {
    var datasource: Array<Any>? { get set }
    var type: SingleSelectionListType? { get set }
    var datasourceDidLoad: ((SingleSelectionListViewModelProtocol) -> ())? { get set }
}

class SingleSelectionListViewModel: SingleSelectionListViewModelProtocol {
    var datasource: Array<Any>?
    var filteredDatasource: Array<Any>?
    var type: SingleSelectionListType?
    var datasourceDidLoad: ((SingleSelectionListViewModelProtocol) -> ())?
    
    required init(type: SingleSelectionListType, params: String) {
        let nc = NotificationCenter.default
        self.datasource = Array<Any>()
        self.filteredDatasource = Array<Any>()
        
        nc.addObserver(forName:Notification.Name(rawValue:"REGS_DID_LOAD"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.datasource?.removeAll()
                        strongSelf.datasource = notification.userInfo?["regions"] as! Array<Dictionary<String, Any>>
                        strongSelf.type = .singleSelectionListRegs
                        strongSelf.filteredDatasource = strongSelf.datasource
                        strongSelf.datasourceDidLoad!(strongSelf)
        }
        
        nc.addObserver(forName:Notification.Name(rawValue:"MUNS_DID_LOAD"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.datasource?.removeAll()
                        strongSelf.datasource = notification.userInfo?["municipalities"] as! Array<Municipality>
                        strongSelf.type = .singleSelectionListMuns
                        strongSelf.filteredDatasource = strongSelf.datasource
                        strongSelf.datasourceDidLoad!(strongSelf)
        }
        
        if type == .singleSelectionListRegs{
            DataManager.sharedInstance.allRegions()
        } else {
            DataManager.sharedInstance.municipalities(with: params)
        }
    }
}
