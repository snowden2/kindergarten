//
//  RequestManager.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 14/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import Foundation
import Alamofire

let yandexGeocode = "https://geocode-maps.yandex.ru/1.x/"

let prodAPIHost = "https://cabinetv4.do.edu.ru"
let testAPIHost = "http://nexus.dev.informika.ru:8081"
let reserveTestAPIHost = "http://eot.dev.informika.ru"

let objectsWithCoordsAPI = "/open/getOrgsByLatLon"
let kindergartenWithIdentifierAPI = "/mobileapi/organizations/get/"
let federalsAPI = "/open/getFeds"
let regionsAPI = "/open/getRegs"
let municipalitiesAPI = "/private/getMunsByRegId"
let searchObjectsWithParamsAPI = "/open/find"

class RequestManager {
    
    static let sharedInstance = RequestManager()
    
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
    //var sessionId = ""
    
    func objects(with coords: Array<CLLocationCoordinate2D>, completion: @escaping (Any) -> Void) {
        let url = String(format: "%@%@", testAPIHost, objectsWithCoordsAPI)
        let parameters = ["lonLeft": coords[0].longitude,
                          "lonRight": coords[1].longitude,
                          "latLow": coords[1].latitude,
                          "latHigh": coords[0].latitude]
        makeRequest(with: url, parameters: parameters) { (responseData) in
            completion(responseData)
        }
    }
    
    func kindergarten(with id: String, completion: @escaping (Any) -> Void) {
        let url = String(format: "%@%@%@", testAPIHost, kindergartenWithIdentifierAPI, id)
        makeRequest(with: url, parameters: nil) { (responseData) in
            completion(responseData)
        }
    }
    
    func allRegions(completion: @escaping (Any) -> Void) {
        let url = String(format: "%@%@", testAPIHost, regionsAPI)
        makeRequest(with: url, parameters: nil) { (responseData) in
            completion(responseData)
        }
    }
    
    func municipalities(with region: String, completion: @escaping (Any) -> Void) {
        let url = String(format: "%@%@%", testAPIHost, municipalitiesAPI)
        let parameters = ["regId": region]
        makeRequest(with: url, parameters: parameters) { (responseData) in
            completion(responseData)
        }
    }
    
    func searchObjects(with dict: Dictionary<String, String>, completion: @escaping (Any) -> Void) {
        var parameters = Dictionary<String, String>()
        if let regId = dict["regId"] {
            parameters["regId"] = regId
        }
        if let munId = dict["munId"] {
            parameters["munId"] = munId
        }
        if let type = dict["type"] {
            parameters["type"] = type
        }
        if let status = dict["status"] {
            parameters["status"] = status
        }
        if let structure = dict["structure"] {
            parameters["structure"] = structure
        }
        if let licence = dict["licence"] {
            parameters["licence"] = licence
        }
        if let age_from = dict["age_from"] {
            parameters["age_from"] = age_from
        }
        if let age_to = dict["age_to"] {
            parameters["age_to"] = age_to
        }
        if let orientation = dict["orientation"] {
            parameters["orientation"] = orientation
        }
        if let ovzType = dict["ovzType"] {
            parameters["ovzType"] = ovzType
        }
        if let wellness = dict["wellness"] {
            parameters["wellness"] = wellness
        }
        if let worktime_group = dict["worktime_group"] {
            parameters["worktime_group"] = worktime_group
        }
        if let activity = dict["activity"] {
            parameters["activity"] = activity
        }
        if let free_space = dict["free_space"] {
            parameters["free_space"] = free_space
        }
        let url = String(format: "%@%@", testAPIHost, searchObjectsWithParamsAPI)
        makeRequest(with: url, parameters: parameters) { (responseData) in
            completion(responseData)
        }
    }
    
    func searchAddress(with text: String, completion: @escaping (Any) -> Void) {
        let parameters = ["format": "json",
                          "geocode": "Россия+\(text.replacingOccurrences(of: " ", with: "+"))"]
        makeRequest(with: yandexGeocode, parameters: parameters) { (responseData) in
            completion(responseData)
        }
    }
    
    func makeRequest(with url: String, parameters: Dictionary<String, Any>?, completion: @escaping (Any) -> Void) {
        Alamofire.request(url, parameters: parameters).response { (response) in
            print("\(Date()): FINISH REQUEST WITH DURATION \(response.timeline.requestDuration)")
            completion(response.data!)
        }
        
        /*Alamofire.request(url, parameters: parameters).responseJSON { (response) in
            // check for any errors
            guard response.error == nil else {
                print("Error calling GET")
                return
            }
            // make sure we got data
            guard let responseData = response.result.value else {
                print("Error: did not receive data")
                return
            }
            print("\(Date()): FINISH REQUEST")
            completion(responseData)
        }*/
    }
    
}
