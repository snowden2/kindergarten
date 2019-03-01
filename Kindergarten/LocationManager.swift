//
//  LocationManager.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 17/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocationCoordinate2D?
    
    //This prevents others from using the default '()' initializer for this class.
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLocationManagerAuthorizedNotification), object: nil)
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    func getCurrentLocation() -> CLLocationCoordinate2D? {
        guard currentLocation != nil else {
            print("No data for current location yet")
            return nil
        }
        return currentLocation!
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            currentLocation = (locationManager.location?.coordinate)!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLocationManagerAuthorizedNotification), object: nil)
        }
    }
    
}
