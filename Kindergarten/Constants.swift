//
//  Constants.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 17/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

// Yandex Map Kit

let kYandexMapKitAPIKey = "HjHFsHLDYATIkkcrK-0efXn-iq2PEFLIRnwyHJ-IIyQDRpPi92YBLAA-KJWP6BwJwT~GTe-UcHBtBrzcdUyt0WJkb9TyBhCbboj9LQpHlmo="

// Notification Center

let kLocationManagerAuthorizedNotification = "ru.nd.informika.Kindergarten.LocationManagerAuthorized"

// Infographics

enum InfographicsType: Int {
    case enrollKindergarten
    case changeKindergarten
    case notEnrolledKindergarten
}

// Common

let kPropertyTypeAny = "Не важно"
let kPropertyTypeStateOrMunicipal = "Муниципальные и государственные"
let kPropertyTypePrivateOrEnterpreneur = "Частные и ИП"

let kFunctionStatusAny = "Не важно"
let kFunctionStatusActive = "Функционирует"

let kStructureTypeKindergarten = "Детский сад"
let kStructureTypeSchoolGroups = "Группы при школе"
let kStructureTypeOtherGroups = "Группы при другой организации"

let kOrientationTypeCommon = "Общеразвивающая"
let kOrientationTypeHandicap = "Для детей с ОВЗ"
let kOrientationTypeWelness = "Оздоровительная"
let kOrientationTypeCare = "Присмотра и ухода"
let kOrientationTypeFamily = "Семейная"

let kWorkingHoursTypeShort = "Кратковременного пребывания (до 5 часов в день)"
let kWorkingHoursTypeDayShorted = "Сокращенного дня (8 - 10 часового пребывания)"
let kWorkingHoursTypeDayFull = "Полного дня (10,5 - 12 часового пребывания)"
let kWorkingHoursTypeDayExtended = "Продленного дня (13 - 14 часового пребывания)"
let kWorkingHoursTypeFullTime = "Круглосуточного пребывания (24 часа)"

let kActivityTypeEducation = "Реализация образовательных программ"
let kActivityTypeCare = "Присмотр и уход за детьми"

let kHandicapTreatmentTypeHearing = "С нарушением слуха"
let kHandicapTreatmentTypeSpeech = "С нарушением речи"
let kHandicapTreatmentTypeEyesight = "С нарушением зрения"
let kHandicapTreatmentTypeMentalRetardation = "С нарушением интеллекта"
let kHandicapTreatmentTypePsychicDevelopmentOrAutism = "С задержкой психического развития"
let kHandicapTreatmentTypeMovement = "С нарушением опорно-двигательного аппарата"
let kHandicapTreatmentTypeComplexCases = "Со сложным дефектом"
let kHandicapTreatmentTypeOther = "Другого профиля"

let kWellnessTypeTuberculosis = "Группа для детей с туберкулезной интоксикацией"
let kWellnessTypeFrequentIllness = "Группа для часто болеющих детей"
let kWellnessTypeOther = "Иной профиль группы"

let kAgeSixMonths = "6 мес"
let kAgeOne = "1 год"
let kAgeOneAndHalf = "1.5 года"
let kAgeTwo = "2 года"
let kAgeTwoAndHalf = "2.5 года"
let kAgeThree = "3 года"
let kAgeThreeAndHalf = "3.5 года"
let kAgeFour = "4 года"
let kAgeFourAndHalf = "4.5 года"
let kAgeFive = "5 лет"
let kAgeFiveAndHalf = "5.5 лет"
let kAgeSix = "6 лет"
let kAgeSixAndHalf = "6.5 лет"
let kAgeSeven = "7 лет"
let kAgeSevenAndHalf = "7.5 лет"
let kAgeEight = "8 лет"

let kTwoMonthsToYear = "от 2 мес. до 1 года"
let kOneYearToTwoYears = "от 1 до 2 лет"
let kTwoYearsToThreeYears = "от 2 до 3 лет"
let kThreeYearsToFourYears = "от 3 до 4 лет"
let kFourYearsToFiveYears = "от 4 до 5 лет"
let kFiveYearsToSixYears = "от 5 до 6 лет"
let kSixYearsToSevenYears = "от 6 до 7 лет"
let kSevenYearsAndUp = "от 7 лет и старше"

enum SingleSelectionListType {
    case singleSelectionListRegs
    case singleSelectionListMuns
}

enum SearchKindergartenParamsSelectionType {
    case singleParamSelection
    case multiParamsSelection
}

enum SearchKindergartenParamsType: Int, CustomStringConvertible {
    case propertyParamsType
    case functionParamsType
    case structureParamsType
    case orientationParamsType
    case treatmentParamsType
    case wellnessParamsType
    case workingHoursParamsType
    case activityParamsType
    
    var description: String {
        switch self {
        case .propertyParamsType:
            return "Тип собственности"
        case .functionParamsType:
            return "Статус сада"
        case .structureParamsType:
            return "Вид сада"
        case .orientationParamsType:
            return "Направленность сада"
        case .treatmentParamsType:
            return "Для детей с ОВЗ"
        case .wellnessParamsType:
            return "Оздоровительная"
        case .workingHoursParamsType:
            return "Режим работы"
        case .activityParamsType:
            return "Вид деятельности"
        }
    }
}
