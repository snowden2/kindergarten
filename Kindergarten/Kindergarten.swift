//
//  Kindergarten.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 07.08.17.
//  Copyright © 2017 Informika. All rights reserved.
//

import Foundation

enum KindergartenPropertyType: Int, CustomStringConvertible {
    case KindergartenPropertyTypeUndefined
    case KindergartenPropertyTypeMunicipal
    case KindergartenPropertyTypeState
    case KindergartenPropertyTypePrivateLicensed
    case KindergartenPropertyTypePrivateUnlicensed
    case KindergartenPropertyTypeEnterpreneurLicensed
    case KindergartenPropertyTypeEnterpreneurUnlicnsed
    case KindergartenPropertyTypeFederal
    
    var description: String {
        switch self {
        case .KindergartenPropertyTypeUndefined:
            return "Нет данных"
        case .KindergartenPropertyTypeMunicipal:
            return "Муниципальная"
        case .KindergartenPropertyTypeState:
            return "Государственная"
        case .KindergartenPropertyTypePrivateLicensed:
            return "Частная с лицензией"
        case .KindergartenPropertyTypePrivateUnlicensed:
            return "Частная"
        case .KindergartenPropertyTypeEnterpreneurLicensed:
            return "ИП с лицензией"
        case .KindergartenPropertyTypeEnterpreneurUnlicnsed:
            return "ИП"
        case .KindergartenPropertyTypeFederal:
            return "Федеральная"
        }
    }
}

enum KindergartenStructureType: Int, CustomStringConvertible {
    case KindergartenStructureTypeUndefined
    case KindergartenStructureTypePreSchool
    case KindergartenStructureTypeCommonSchoolBasedGroups
    case KindergartenStructureTypeCommonOrganizationBaseGroups
    case KindergartenStructureTypeHighSchoolBasedGroups
    
    var description: String {
        switch self {
        case .KindergartenStructureTypeUndefined:
            return "Нет данных"
        case .KindergartenStructureTypePreSchool:
            return "Детский сад"
        case .KindergartenStructureTypeCommonSchoolBasedGroups:
            return "Группы при школе"
        case .KindergartenStructureTypeCommonOrganizationBaseGroups:
            return "Группы при организации"
        case .KindergartenStructureTypeHighSchoolBasedGroups:
            return "Группы при ВУЗе"
        }
    }
}

enum KindergartenFunctionStatus: Int, CustomStringConvertible {
    case KindergartenFunctionStatusUndefined
    case KindergartenFunctionStatusFunctioning
    case KindergartenFunctionStatusCapitalReconstruction
    case KindergartenFunctionStatusReconstruction
    case KindergartenFunctionStatusSuspended
    case KindergartenFunctionStatusNoKids
    case KindergartenFunctionStatusWaitingToOpen
    
    var description: String {
        switch self {
        case .KindergartenFunctionStatusUndefined:
            return "Нет данных"
        case .KindergartenFunctionStatusFunctioning:
            return "Функционирует"
        case .KindergartenFunctionStatusCapitalReconstruction:
            return "Капитальный ремонт"
        case .KindergartenFunctionStatusReconstruction:
            return "Реконструкция"
        case .KindergartenFunctionStatusSuspended:
            return "Деятельность приостановлена"
        case .KindergartenFunctionStatusNoKids:
            return "Контингент отсутствует"
        case .KindergartenFunctionStatusWaitingToOpen:
            return "Ожидает открытия"
        }
    }
}

struct Kindergarten {
    var id: String
    var name: String
    var plainAddress: String
    var legalAddress: String
    var email: String
    var phone: String
    var webSite: String
    var isLicensed: Bool
    var workingHours: String
    var additionalEducation: String
    var feature: String
    var numberOfGroups: Int
    var munId: Int
    
    var propertyType: KindergartenPropertyType
    var functionStatus: KindergartenFunctionStatus
    var structureType: KindergartenStructureType
    
    var numberOfKids: KindergartenSummary
    var priorityNeedsForCurrentYear: KindergartenSummary
    var priorityNeedsForNextYear: KindergartenSummary
    var commonWaitingTime: KindergartenSummary
    var nonPrivelegedWaitingTime: KindergartenSummary
    var privelegedWaitingTime: KindergartenSummary
    var handicappedWaitingTime: KindergartenSummary
    
    var buildings: Array<Building>?
}
