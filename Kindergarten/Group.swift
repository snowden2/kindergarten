//
//  Group.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 07.08.17.
//  Copyright © 2017 Informika. All rights reserved.
//

import Foundation

enum GroupActivityType: Int, CustomStringConvertible {
    case GroupActivityTypeEducation
    case GroupActivityTypeCare
    case GroupActivityTypeUndefined
    
    var description: String {
        switch self {
        case .GroupActivityTypeEducation:
            return "Реализация образовательных программ"
        case .GroupActivityTypeCare:
            return "Присмотр и уход за детьми"
        case .GroupActivityTypeUndefined:
            return "Нет данных"
        }
    }
}

enum GroupOrientationType: Int, CustomStringConvertible {
    case GroupOrientationTypeOverall
    case GroupOrientationTypeCompensation
    case GroupOrientationTypeCorrection
    case GroupOrientationTypeWellness
    case GroupOrientationTypeJunior
    case GroupOrientationTypeCare
    case GroupOrientationTypePreSchool
    case GroupOrientationTypeUndefined
    
    var description: String {
        switch self {
        case .GroupOrientationTypeOverall:
            return "Общеразвивающая"
        case .GroupOrientationTypeCompensation:
            return "Компенсирующая"
        case .GroupOrientationTypeCorrection:
            return "Комбинированная"
        case .GroupOrientationTypeWellness:
            return "Оздоровительная"
        case .GroupOrientationTypeJunior:
            return "Раннего возраста"
        case .GroupOrientationTypeCare:
            return "Присмотра и ухода"
        case .GroupOrientationTypePreSchool:
            return "Семейная"
        case .GroupOrientationTypeUndefined:
            return "Нет данных"
        }
    }
}

// GroupOrientationTypeWellness
enum GroupWellnessType: Int, CustomStringConvertible {
    case GroupWellnessTypeNone
    case GroupWellnessTypeTuberculosis
    case GroupWellnessTypeFrequentIllness
    case GroupWellnessTypeOther
    case GroupWellnessTypeUndefined
    
    var description: String {
        switch self {
        case .GroupWellnessTypeNone:
            return "Нет"
        case .GroupWellnessTypeTuberculosis:
            return "Для детей с туберкулезной интоксикацией"
        case .GroupWellnessTypeFrequentIllness:
            return "Для часто болеющих детей"
        case .GroupWellnessTypeOther:
            return "Иной профиль"
        case .GroupWellnessTypeUndefined:
            return "Нет данных"
        }
    }
}

// GroupOrientationTypeCompensation && GroupOrientationTypeCorrection
enum GroupHandicapTreatmentType: Int, CustomStringConvertible {
    case GroupHandicapTreatmentTypeNone
    case GroupHandicapTreatmentTypeHearing
    case GroupHandicapTreatmentTypeSpeech
    case GroupHandicapTreatmentTypeEyesight
    case GroupHandicapTreatmentTypeMentalRetardation
    case GroupHandicapTreatmentTypePsychicDevelopmentOrAutism
    case GroupHandicapTreatmentTypeMovement
    case GroupHandicapTreatmentTypeComplexCases
    case GroupHandicapTreatmentTypeOther
    case GroupHandicapTreatmentTypeUndefinded
    
    var description: String {
        switch self {
        case .GroupHandicapTreatmentTypeNone:
            return "Нет"
        case .GroupHandicapTreatmentTypeHearing:
            return "С нарушением слуха"
        case .GroupHandicapTreatmentTypeSpeech:
            return "С нарушением речи"
        case .GroupHandicapTreatmentTypeEyesight:
            return "С нарушением зрения"
        case .GroupHandicapTreatmentTypeMentalRetardation:
            return "С нарушением интеллекта"
        case .GroupHandicapTreatmentTypePsychicDevelopmentOrAutism:
            return "С задержкой психического развития"
        case .GroupHandicapTreatmentTypeMovement:
            return "С нарушением опорно-двигательного аппарата"
        case .GroupHandicapTreatmentTypeComplexCases:
            return "Со сложным дефектом"
        case .GroupHandicapTreatmentTypeOther:
            return "Иной профиль"
        case .GroupHandicapTreatmentTypeUndefinded:
            return "Нет данных"
        }
    }
}

enum GroupWorkingHours: Int, CustomStringConvertible {
    case GroupWorkingHoursShort
    case GroupWorkingHoursDayShorted
    case GroupWorkingHoursDayFull
    case GroupWorkingHoursDayExtended
    case GroupWorkingHoursFullTime
    case GroupWorkingHoursUndefined
    
    var description: String {
        switch self {
        case .GroupWorkingHoursShort:
            return "Кратковременного пребывания (до 5 часов в день)"
        case .GroupWorkingHoursDayShorted:
            return "Сокращенного дня (8-10 часового пребывания)"
        case .GroupWorkingHoursDayFull:
            return "Полного дня (10,5-12 часового пребывания)"
        case .GroupWorkingHoursDayExtended:
            return "Продленного дня (13-14 часового пребывания)"
        case .GroupWorkingHoursFullTime:
            return "Круглосуточного пребывания (24 часа)"
        case .GroupWorkingHoursUndefined:
            return "Нет данных"
        }
    }
}

struct Group {
    var groupName: String
    var groupId: String
    var buildingId: String
    var ageFrom: String
    var ageTo: String
    var numberAssignedToGroup: String
    var orientationType: GroupOrientationType
    var workingHours: GroupWorkingHours
    var activityType: GroupActivityType
    var wellnessType: GroupWellnessType
    var handicapTreatmentType: GroupHandicapTreatmentType
    var capacity: Int
    var enrolled: Int
    var freeSpace: Int
}
