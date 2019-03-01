//
//  MapViewModel.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 17/08/2017.
//  Copyright © 2017 Informika. All rights reserved.
//

import Foundation

protocol MapViewModelProtocol: class {
    var mapObjects: Array<PointAnnotation>? { get }
    var visibleMapObjects: Array<PointAnnotation>? { get }
    var mapObjectsDidLoad: ((MapViewModelProtocol) -> ())? { get set } // function to call when map objects did load
    var locationManagerAuthorized: ((MapViewModelProtocol) -> ())? { get set }
    func getMapObjects(with coords: Array<CLLocationCoordinate2D>)
    func updateVisibleAnnotationsInMapRect(rect: YMKMapRect)
}

class MapViewModel: MapViewModelProtocol {
    
    private var currentLocation: CLLocationCoordinate2D?
    
    var mapObjects: Array<PointAnnotation>?
    var visibleMapObjects: Array<PointAnnotation>?
    var mapObjectsDidLoad: ((MapViewModelProtocol) -> ())?
    var locationManagerAuthorized: ((MapViewModelProtocol) -> ())?

    required init() {
        currentLocation = LocationManager.sharedInstance.getCurrentLocation()
        mapObjects = Array<PointAnnotation>()
        visibleMapObjects = Array<PointAnnotation>()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCurrentLocation), name: NSNotification.Name(rawValue: kLocationManagerAuthorizedNotification), object: nil)
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"OBJECTS_DID_LOAD"), object:nil, queue:nil) { [weak self] notification in
            guard let strongSelf = self else {
                return
            }
            strongSelf.updateMapObjects(newMapObjects: notification.userInfo?["objects"] as! Array<PointAnnotation>)
            strongSelf.visibleMapObjects?.removeAll()
            strongSelf.mapObjectsDidLoad!(strongSelf)
        }
    }
    
    // MARK: - Private methods
    
    func getCurrentLocation() -> CLLocationCoordinate2D {
        return currentLocation!
    }
    
    
    func updateMapObjects(newMapObjects: Array<PointAnnotation>) {
        mapObjects = newMapObjects
    }
    
    // MARK: - Public methods
    
    func getMapObjects(with coords: Array<CLLocationCoordinate2D>) {
        DataManager.sharedInstance.objects(with: coords)
    }
    
    func getSearchRegion() -> YMKMapRegion {
        var minLat = 85.0
        var maxLat = -85.0
        var minLon = 180.0
        var maxLon = -180.0
        var latDistance = 0.0
        var lonDistance = 0.0
        
        for annotation in mapObjects! {
            if annotation.coords.latitude > maxLat {
                maxLat = annotation.coords.latitude
            }
            if annotation.coords.latitude < minLat {
                minLat = annotation.coords.latitude
            }
            if annotation.coords.longitude > maxLon {
                maxLon = annotation.coords.longitude
            }
            if annotation.coords.longitude < minLon {
                minLon = annotation.coords.longitude
            }
        }
        
        /*if minLat < 0 {
            minLat *= -1
        }
        
        if minLon < 0 {
            minLon *= -1
        }*/
        
        latDistance = maxLat - minLat
        lonDistance = maxLon - minLon
        
        let center = YMKMapCoordinate(latitude: (maxLat + minLat) / 2, longitude: (maxLon + minLon) / 2)
        
        return YMKMapRegion(center: center, span: YMKMapRegionSize(latitudeDelta: latDistance, longitudeDelta: lonDistance))
    }
    
    func updateVisibleAnnotationsInMapRect(rect: YMKMapRect) {
        var annotationsInMapRect = Array<PointAnnotation>()
        
        print("==========================================================================================")
        print("Visible annotations count = \(visibleMapObjects!.count)")
        print("Check rect = \(rect)")
        
        var latSum = 0.0
        var lonSum = 0.0
        
        for annotation in mapObjects! {
            if YMKMapRectContainsMapCoordinate(rect, annotation.coordinate()) {
                annotationsInMapRect.append(annotation)
                latSum += annotation.coords.latitude
                lonSum += annotation.coords.longitude
            }
        }
        
        print("Found \(annotationsInMapRect.count) annotations in rect")
        
        if annotationsInMapRect.count > 0 {
            if annotationsInMapRect.count == 1 {
                let singleAnnotation = annotationsInMapRect.first!
                visibleMapObjects?.append(singleAnnotation)
                print("Add simple annotation to visible array")
            } else {
                let latCenter = latSum / Double(annotationsInMapRect.count)
                let lonCenter = lonSum / Double(annotationsInMapRect.count)
                let centerCoord = CLLocationCoordinate2D(latitude: latCenter, longitude: lonCenter)
                let clusterPointAnnotation = PointAnnotation(organizationId: "-1", name: "ClusterAnnotation", type: -1, status: 0, phone: "", address: "", coords: centerCoord, clusterAnnotaions: annotationsInMapRect)
                
                visibleMapObjects?.append(clusterPointAnnotation)
                print("Add cluster annotation (a:\(annotationsInMapRect.count)) to visible array")
            }
        }
        
        print("==========================================================================================")
        print("")
    }
    
    // MARK: - Notification center methods
    
    @objc func updateCurrentLocation() {
        currentLocation = LocationManager.sharedInstance.getCurrentLocation()
        DispatchQueue.main.async {
            self.locationManagerAuthorized!(self)
        }
    }
    
}
