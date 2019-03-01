//
//  DataManager.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 15/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import Foundation
import SwiftyJSON
import MessageUI

class DataManager: NSObject, MFMailComposeViewControllerDelegate {
    
    static let sharedInstance = DataManager()
    
    private var kindergartens = Array<Kindergarten>()
    private var mapObjects = Array<PointAnnotation>()
    private var regions = Array<Dictionary<String, Any>>()
    private var municipalities = Array<Municipality>()
    
    private var regId = ""
    private var regName = ""
    private var munId = 0
    private var step = 0
    
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    private func mapObjectsFromData(data: Any) {
        self.mapObjects.removeAll()
        self.kindergartens.removeAll()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            let objectsArray = JSON(data)
            for object in objectsArray {
                if (object.1["lat"].null != nil) || (object.1["lon"].null != nil) {
                    continue
                }
                
                let mapObject = PointAnnotation(organizationId: object.1["id"].string!, name: object.1["name"].string!, type: object.1["type"].int!, status: object.1["status"].int!, phone: strongSelf.transformPhone(phone: object.1["phone"].string!), address: object.1["address"].string!, coords: YMKMapCoordinate(latitude: object.1["lat"].double!, longitude: object.1["lon"].double!), clusterAnnotaions: nil)
                strongSelf.mapObjects.append(mapObject)
                
                let kindergarten = Kindergarten(id: object.1["id"].string!, name: object.1["name"].string!, plainAddress: object.1["address"].string!, legalAddress: object.1["address"].string!, email: object.1["email"].string!, phone: strongSelf.transformPhone(phone: object.1["phone"].string!), webSite: object.1["website"].string!, isLicensed: Bool(object.1["license"].int! as NSNumber), workingHours: object.1["worktime"].string!, additionalEducation: object.1["additionalEducation"].string!, feature: object.1["feature"].string!, numberOfGroups: object.1["numberGroup"].int!, munId: object.1["munId"].int!, propertyType: KindergartenPropertyType(rawValue: object.1["type"].int!)!, functionStatus: KindergartenFunctionStatus(rawValue: object.1["status"].int!)!, structureType: KindergartenStructureType(rawValue: object.1["structure"].int!)!, numberOfKids: KindergartenSummary(total: object.1["quantity_19_1"]["total"].int!, twoMonthsToOneYear: object.1["quantity_19_1"]["y0"].int!, oneYearToTwoYears: object.1["quantity_19_1"]["y1"].int!, twoYearsToThreeYears: object.1["quantity_19_1"]["y2"].int!, threeYearsToFourYears: object.1["quantity_19_1"]["y3"].int!, fourYearsToFiveYears: object.1["quantity_19_1"]["y4"].int!, fiveYearsToSixYears: object.1["quantity_19_1"]["y5"].int!, sixYearsToSevenYears: object.1["quantity_19_1"]["y6"].int!, sevenYearsAndUp: object.1["quantity_19_1"]["y7"].int!), priorityNeedsForCurrentYear: KindergartenSummary(total: object.1["need_current"]["total"].int!, twoMonthsToOneYear: object.1["need_current"]["y0"].int!, oneYearToTwoYears: object.1["need_current"]["y1"].int!, twoYearsToThreeYears: object.1["need_current"]["y2"].int!, threeYearsToFourYears: object.1["need_current"]["y3"].int!, fourYearsToFiveYears: object.1["need_current"]["y4"].int!, fiveYearsToSixYears: object.1["need_current"]["y5"].int!, sixYearsToSevenYears: object.1["need_current"]["y6"].int!, sevenYearsAndUp: object.1["need_current"]["y7"].int!), priorityNeedsForNextYear: KindergartenSummary(total: object.1["need_next_7_5"]["total"].int!, twoMonthsToOneYear: object.1["need_next_7_5"]["y0"].int!, oneYearToTwoYears: object.1["need_next_7_5"]["y1"].int!, twoYearsToThreeYears: object.1["need_next_7_5"]["y2"].int!, threeYearsToFourYears: object.1["need_next_7_5"]["y3"].int!, fourYearsToFiveYears: object.1["need_next_7_5"]["y4"].int!, fiveYearsToSixYears: object.1["need_next_7_5"]["y5"].int!, sixYearsToSevenYears: object.1["need_next_7_5"]["y6"].int!, sevenYearsAndUp: object.1["need_next_7_5"]["y7"].int!), commonWaitingTime: KindergartenSummary(total: 0, twoMonthsToOneYear: 0, oneYearToTwoYears: 0, twoYearsToThreeYears: 0, threeYearsToFourYears: 0, fourYearsToFiveYears: 0, fiveYearsToSixYears: 0, sixYearsToSevenYears: 0, sevenYearsAndUp: 0), nonPrivelegedWaitingTime: KindergartenSummary(total: 0, twoMonthsToOneYear: 0, oneYearToTwoYears: 0, twoYearsToThreeYears: 0, threeYearsToFourYears: 0, fourYearsToFiveYears: 0, fiveYearsToSixYears: 0, sixYearsToSevenYears: 0, sevenYearsAndUp: 0), privelegedWaitingTime: KindergartenSummary(total: 0, twoMonthsToOneYear: 0, oneYearToTwoYears: 0, twoYearsToThreeYears: 0, threeYearsToFourYears: 0, fourYearsToFiveYears: 0, fiveYearsToSixYears: 0, sixYearsToSevenYears: 0, sevenYearsAndUp: 0), handicappedWaitingTime: KindergartenSummary(total: 0, twoMonthsToOneYear: 0, oneYearToTwoYears: 0, twoYearsToThreeYears: 0, threeYearsToFourYears: 0, fourYearsToFiveYears: 0, fiveYearsToSixYears: 0, sixYearsToSevenYears: 0, sevenYearsAndUp: 0), buildings: nil)
                strongSelf.kindergartens.append(kindergarten)
            }
            print("\(Date()): FINISH")
            
            if strongSelf.mapObjects.count > 0 {
                NotificationCenter.default.post(name:Notification.Name(rawValue:"OBJECTS_DID_LOAD"),
                                                object: nil,
                                                userInfo: ["objects":strongSelf.mapObjects])
            } else {
                if let region = UserDefaults.standard.string(forKey: "SELECTED_REGION") {
                    strongSelf.searchAddress(with: region, completion: { (mapSearchResults) in
                        NotificationCenter.default.post(name:Notification.Name(rawValue:"SET_REGION"),
                                                        object: nil,
                                                        userInfo: ["region":mapSearchResults])
                    })
                }
            }
            
        }
    }
    
    func objects(with coords: Array<CLLocationCoordinate2D>) {
        print("\(Date()): START")
        RequestManager.sharedInstance.objects(with: coords) { [unowned self] (responseData) in
            self.mapObjectsFromData(data: responseData)
        }
    }
    
    func kindergartenById(id: String) -> Kindergarten? {
        return kindergartens.filter { $0.id.contains(id) }.first
    }
    
    func allRegions() {
        regions.removeAll()
        RequestManager.sharedInstance.allRegions { [weak self] (responseData) in
            guard let strongSelf = self else {
                return
            }
            let regionsArray = JSON(responseData)
            for region in regionsArray {
                strongSelf.regions.append(["id":region.1["id"].int!,"fullname":region.1["fullName"].string!])
            }
            
            strongSelf.regions = strongSelf.regions.sorted(by: {"\($0["fullname"]!)" < "\($1["fullname"]!)"})
            NotificationCenter.default.post(name:Notification.Name(rawValue:"REGS_DID_LOAD"),
                                            object: nil,
                                            userInfo: ["regions":strongSelf.regions])
        }
    }
    
    func municipalities(with region: String) {
        municipalities.removeAll()
        RequestManager.sharedInstance.municipalities(with: region) { (responseData) in
            let municipalitiesArray = JSON(responseData)
            for municipality in municipalitiesArray {
                self.municipalities.append(Municipality(id: municipality.1["id"].int!, name: municipality.1["name"].string!, providerName: municipality.1["name"].string!, providerAddress: municipality.1["address"].string!, mainPhone: municipality.1["phones"].string!, secondaryPhone: municipality.1["phones"].string!, email: municipality.1["email"].string!, website: municipality.1["site"].string!, orderUrl: municipality.1["regulation"].string!, areaDocumentUrl: municipality.1["fixArea"].string!, regionalPortalUrl: municipality.1["rpguLink"].string!, federalPortalUrl: municipality.1["epguLink"].string!, preSchoolProvidedTotal: municipality.1["providedAll"].double!, preSchoolProvidedThreeToSeven: municipality.1["provided37"].double!, preSchoolUnprovidedTotal: municipality.1["notProvidedAll"].double!, preSchoolUnprovidedOneAndHalfToThree: municipality.1["notProvided153"].double!, preSchoolUnprovidedThreeToSeven: municipality.1["notProvided37"].double!))
            }
            
            self.municipalities = self.municipalities.sorted(by: {$0.name < $1.name})
            NotificationCenter.default.post(name:Notification.Name(rawValue:"MUNS_DID_LOAD"),
                                            object: nil,
                                            userInfo: ["municipalities":self.municipalities])
        }
    }
    
    func checkNextMun() {
        let region = regions[step]
        var findNext = true
        RequestManager.sharedInstance.municipalities(with: "\(region["id"]!)") { [weak self] (responseData) in
            guard let strongSelf = self else {
                return
            }
            let municipalitiesArray = JSON(responseData)
            for municipality in municipalitiesArray {
                let munId = municipality.1["id"].int!
                if munId == strongSelf.munId {
                    findNext = false
                    let mun = Municipality(id: municipality.1["id"].int!, name: municipality.1["name"].string!, providerName: municipality.1["name"].string!, providerAddress: municipality.1["address"].string!, mainPhone: municipality.1["phones"].string!, secondaryPhone: municipality.1["phones"].string!, email: municipality.1["email"].string!, website: municipality.1["site"].string!, orderUrl: municipality.1["regulation"].string!, areaDocumentUrl: municipality.1["fixArea"].string!, regionalPortalUrl: municipality.1["rpguLink"].string!, federalPortalUrl: municipality.1["epguLink"].string!, preSchoolProvidedTotal: municipality.1["providedAll"].double!, preSchoolProvidedThreeToSeven: municipality.1["provided37"].double!, preSchoolUnprovidedTotal: municipality.1["notProvidedAll"].double!, preSchoolUnprovidedOneAndHalfToThree: municipality.1["notProvided153"].double!, preSchoolUnprovidedThreeToSeven: municipality.1["notProvided37"].double!)
                    NotificationCenter.default.post(name:Notification.Name(rawValue:"REGMUN_OK"),
                                                    object: nil,
                                                    userInfo: ["regId":region["id"]!,"regName":region["fullname"] as! String,"municipality":mun])
                    break
                }
            }
            
            strongSelf.step += 1
            if findNext {
                strongSelf.checkNextMun()
            }
        }
    }
    
    func getRegMun(by munId: Int) {
        step = 0
        self.munId = munId
        regions.removeAll()
        RequestManager.sharedInstance.allRegions { [weak self] (responseData) in
            guard let strongSelf = self else {
                return
            }
            let regionsArray = JSON(responseData)
            for region in regionsArray {
                strongSelf.regions.append(["id":region.1["id"].int!,"fullname":region.1["fullName"].string!])
            }
            strongSelf.checkNextMun()
        }
    }
    
    func getRegions() -> Array<Dictionary<String, Any>> {
        return regions
    }
    
    func getMunicipalities() -> Array<Municipality> {
        return municipalities
    }
    
    func searchObjects(with dict: Dictionary<String, String>) {
        RequestManager.sharedInstance.searchObjects(with: dict) { [unowned self] (responseData) in
            self.mapObjectsFromData(data: responseData)
        }
    }
    
    func searchAddress(with text: String, completion: @escaping (Array<MapSearchResult>) -> Void) {
        RequestManager.sharedInstance.searchAddress(with: text) { (responseData) in
            let resultDict = JSON(responseData)
            let addressArray = resultDict["response"]["GeoObjectCollection"]["featureMember"]
            var mapSearchResults = Array<MapSearchResult>()
            
            for address in addressArray {
                let coords = address.1["GeoObject"]["Point"]["pos"].string!.components(separatedBy: " ")
                mapSearchResults.append(MapSearchResult(title: address.1["GeoObject"]["metaDataProperty"]["GeocoderMetaData"]["text"].string!, latitude: Double(coords[1])!, longitude: Double(coords[0])!))
            }
            
            completion(mapSearchResults)
        }
    }

    // MARK: - Favorites
    
    func getFavorites() -> Array<String>? {
        return UserDefaults.standard.object(forKey: "FAVORITES") as? Array<String>
    }
    
    func updateFavorites(kindergartenId: String, remove: Bool) {
        let ud = UserDefaults.standard
        var favorites = ud.object(forKey: "FAVORITES") as! Array<String>?
        
        if favorites != nil {
            if !remove {
                if !(favorites?.contains(kindergartenId))! {
                    favorites?.append(kindergartenId)
                }
            } else {
                if (favorites?.contains(kindergartenId))! {
                    favorites = favorites?.filter(){$0 != kindergartenId}
                }
            }
        } else {
            favorites = Array<String>()
            favorites?.append(kindergartenId)
        }
        
        ud.set(favorites, forKey: "FAVORITES")
        
        NotificationCenter.default.post(name:Notification.Name(rawValue:"UPDATE_FAVORITES"),
                                        object: nil,
                                        userInfo: nil)
    }
    
    func isFavorite(kindergartenId: String) -> Bool {
        let favorites = UserDefaults.standard.object(forKey: "FAVORITES") as! Array<String>?
        
        if favorites != nil {
            return (favorites?.contains(kindergartenId))!
        }
        
        return false
    }
    
    // MARK: - Common utils
    
    func getAgeRangs() -> Array<String> {
        var ranges = Array<String>()
        ranges.append(kAgeSixMonths)
        ranges.append(kAgeOne)
        ranges.append(kAgeOneAndHalf)
        ranges.append(kAgeTwo)
        ranges.append(kAgeTwoAndHalf)
        ranges.append(kAgeThree)
        ranges.append(kAgeThreeAndHalf)
        ranges.append(kAgeFour)
        ranges.append(kAgeFourAndHalf)
        ranges.append(kAgeFive)
        ranges.append(kAgeFiveAndHalf)
        ranges.append(kAgeSix)
        ranges.append(kAgeSixAndHalf)
        ranges.append(kAgeSeven)
        ranges.append(kAgeSevenAndHalf)
        ranges.append(kAgeEight)
        return ranges
    }
    
    func getParamsList(by type: SearchKindergartenParamsType) -> Array<String>? {
        var params = Array<String>()
        
        switch type {
        case .propertyParamsType:
            params.append(kPropertyTypeAny)
            params.append(kPropertyTypeStateOrMunicipal)
            params.append(kPropertyTypePrivateOrEnterpreneur)
            break
        case .functionParamsType:
            params.append(kFunctionStatusAny)
            params.append(kFunctionStatusActive)
            break
        case .structureParamsType:
            params.append(kStructureTypeKindergarten)
            params.append(kStructureTypeSchoolGroups)
            params.append(kStructureTypeOtherGroups)
            break
        case .orientationParamsType:
            params.append(kOrientationTypeCommon)
            params.append(kOrientationTypeHandicap)
            params.append(kOrientationTypeWelness)
            params.append(kOrientationTypeCare)
            params.append(kOrientationTypeFamily)
            break
        case .wellnessParamsType:
            params.append(kWellnessTypeTuberculosis)
            params.append(kWellnessTypeFrequentIllness)
            params.append(kWellnessTypeOther)
            break
        case .treatmentParamsType:
            params.append(kHandicapTreatmentTypeHearing)
            params.append(kHandicapTreatmentTypeSpeech)
            params.append(kHandicapTreatmentTypeEyesight)
            params.append(kHandicapTreatmentTypeMentalRetardation)
            params.append(kHandicapTreatmentTypePsychicDevelopmentOrAutism)
            params.append(kHandicapTreatmentTypeComplexCases)
            params.append(kHandicapTreatmentTypeOther)
            break
        case .workingHoursParamsType:
            params.append(kWorkingHoursTypeShort)
            params.append(kWorkingHoursTypeDayShorted)
            params.append(kWorkingHoursTypeDayFull)
            params.append(kWorkingHoursTypeDayExtended)
            params.append(kWorkingHoursTypeFullTime)
            break
        case .activityParamsType:
            params.append(kActivityTypeEducation)
            params.append(kActivityTypeCare)
            break
        }
        
        return params
    }
    
    func transformPhone(phone: String) -> String {
        var mainPhone = phone.contains(",") ? phone.components(separatedBy: ",").first! : phone
        
        if mainPhone.characters.count != 10 {
            return mainPhone
        }
        
        var end = mainPhone.index(mainPhone.endIndex, offsetBy: -7)
        var range = mainPhone.startIndex..<end
        let a = mainPhone.substring(with: range)
        
        var start = mainPhone.index(mainPhone.startIndex, offsetBy: 3)
        end = mainPhone.index(mainPhone.endIndex, offsetBy: -4)
        range = start..<end
        let b = mainPhone.substring(with: range)
        
        start = mainPhone.index(mainPhone.startIndex, offsetBy: 6)
        end = mainPhone.index(mainPhone.endIndex, offsetBy: -2)
        range = start..<end
        let c = mainPhone.substring(with: range)
        
        start = mainPhone.index(mainPhone.startIndex, offsetBy: 8)
        range = start..<mainPhone.endIndex
        let d = mainPhone.substring(with: range)
        
        return "8 \(a) \(b) \(c) \(d)"
    }
    
    private func getTopViewController() -> UIViewController {
        var viewController = UIViewController()
        
        if let vc = UIApplication.shared.delegate?.window??.rootViewController {
            
            viewController = vc
            var presented = vc
            
            while let top = presented.presentedViewController {
                presented = top
                viewController = top
            }
        }
        
        return viewController
    }
    
    func showHint(for type: String) {
        let title = type
        var description = ""
        
        if type.contains(SearchKindergartenParamsType.orientationParamsType.description) {
            description = "Особенности функционирования группы"
        }
        if type.contains(kOrientationTypeCommon) {
            description = "В группе осуществляется реализация основной программы дошкольного образования"
        }
        if type.contains(kOrientationTypeCare) {
            description = "В группе не реализуются программы дошкольного образования, обеспечивается комплекс мер по организации питания и хозяйственно-бытового обслуживания детей, обеспечению соблюдения ими личной гигиены и режима дня"
        }
        if type.contains(kOrientationTypeHandicap) {
            description = "В группе осуществляется реализация адаптивной программы дошкольного образования для детей с ограниченными возможностями здоровья (ОВЗ) с учетом особенностей их психофизического развития, индивидуальных возможностей, обеспечивающей коррекцию нарушений развития и социальную адаптацию воспитанников с ОВЗ"
        }
        if type.contains(kOrientationTypeWelness) {
            description = "В группе осуществляется реализация основной программы дошкольного образования, а также комплекс санитарно-гигиенических, лечебно-оздоровительных и профилактических мероприятий и процедур"
        }
        if type.contains(kOrientationTypeFamily) {
            description = "Группа, организованная на базе семьи, может иметь общеразвивающую направленность и/или осуществлять присмотр и уход за детьми без реализации программы дошкольного образования"
        }
        if type.contains("Общее число детей") {
            description = "Общее число детей, зачисленных в данную организацию"
        }
        if type.contains("Приоритетная потребность на текущий год") {
            description = "Число детей, не обеспеченных местом, желающих получить место в настоящее время"
        }
        if type.contains("Приоритетная потребность на следующий год") {
            description = "Число детей, желающих получить место в следующем учебном году"
        }
        if type == "Среднее время ожидания места" {
            description = "Период ожидания места с желаемой даты получения места до даты направления ребенка в детский сад"
        }
        if type == "Среднее время ожидания места для детей без льгот" {
            description = "Период ожидания места для детей без льгот с желаемой даты получения места до даты направления ребенка в детский сад"
        }
        if type == "Среднее время ожидания места для детей, имеющих льготы" {
            description = "Период ожидания места для детей, имеющих льготы при зачислении, с желаемой даты получения места до даты направления ребенка в детский саду"
        }
        if type ==  "Среднее время ожидания места для детей с ОВЗ" {
            description = "Период ожидания места для детей с ограниченными возможностями здоровья с желаемой даты получения места до даты направления ребенка в детский сад"
        }
        if type.contains(SearchKindergartenParamsType.workingHoursParamsType.description) {
            description = "Количество часов, которые работает данная группа"
        }
        if type.contains(kActivityTypeEducation) {
            description = "Обеспечивается реализация основной образовательной программы дошкольного образования и деятельность по присмотру и уходу за детьми"
        }
        if type.contains(kActivityTypeCare) {
            description = "Обеспечивается только присмотр и уход за детьми, без реализации образовательной программы"
        }
        
        let hintController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HintViewController") as! HintViewController
        hintController.hintTitle = title
        hintController.hintDescr = description
        hintController.modalPresentationStyle = .overCurrentContext;
        hintController.providesPresentationContextTransitionStyle = true;
        hintController.definesPresentationContext = true;
        getTopViewController().present(hintController, animated: true, completion: nil)
    }
    
    func makeCall(to phone: String) {
        let url = URL(string: "TEL://\(phone.replacingOccurrences(of: " ", with: ""))")
        if url != nil {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    func openWebsite(with url: String) {
        let url = URL(string: url)
        if url != nil {
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    func sendEmail(to reciept: String) {
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([reciept])
            getTopViewController().present(composeVC, animated: true, completion: nil)
        }
    }
    
    func highlightText(searchText: String, inTargetText targetText: String, wthColor color:UIColor) -> NSMutableAttributedString {
        do {
            let regex = try NSRegularExpression(pattern: searchText, options: .caseInsensitive)
            let range = NSMakeRange(0, targetText.utf16.count)
            let matches = regex.matches(in: targetText, options: .withTransparentBounds, range: range)
            let attributedText = NSMutableAttributedString(string: targetText, attributes: nil)
            for match in matches {
                let matchRange = match.range
                
                if color == UIColor.yellow {
                    attributedText.addAttribute(NSBackgroundColorAttributeName, value: color, range: matchRange)
                } else {
                    let font = UIFont(name: "Helvetica", size: 17)
                    attributedText.addAttribute(NSFontAttributeName, value: font!, range: matchRange)
                }
            }
            return attributedText
        } catch _ {
            NSLog("Error creating regular expresion")
            return NSMutableAttributedString(string: "", attributes: nil)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
