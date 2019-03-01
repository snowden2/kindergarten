//
//  MapViewController.swift
//  Kindergarten
//
//  Created by Sergey Teteryatnik on 07.08.17.
//  Copyright © 2017 Informika. All rights reserved.
//

import UIKit
import MapKit

extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8.0).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
}

class MapViewController: UIViewController, YMKMapViewDelegate, UIGestureRecognizerDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var infographicsButton: UIButton!
    @IBOutlet weak var searchKindergartenButton: UIButton!
    @IBOutlet weak var getToQueueButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var calloutView: CalloutView!
    @IBOutlet weak var calloutName: UILabel!
    @IBOutlet weak var calloutAddress: UILabel!
    @IBOutlet weak var calloutPhone: UILabel!
    @IBOutlet weak var calloutViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var calloutViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var searchResultView: UIView!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var calloutCallButton: UIButton!
    
    var searchController: UISearchController?
    
    var allAnnotationsMapView = YMKMapView()
    var selectedMapObjectId = ""
    var loading = false
    var filterMode = false
    
    var viewModel: MapViewModel! {
        didSet {
            self.viewModel.locationManagerAuthorized = { [weak self] viewModel in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.locateMeWithCoords(coords: strongSelf.viewModel.getCurrentLocation(), animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    strongSelf.updateMapObjects()
                }
            }
            self.viewModel.mapObjectsDidLoad = { [weak self] viewModel in
                guard let strongSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    strongSelf.allAnnotationsMapView.removeAnnotations(strongSelf.allAnnotationsMapView.annotations)
                    
                    strongSelf.loading = false
                    
                    if strongSelf.filterMode {
                        strongSelf.searchIndicator.stopAnimating()
                        strongSelf.searchLabel.text = "Найдено объектов: \((strongSelf.viewModel.mapObjects?.count)!)"
                    }
                    
                    for mapObject in strongSelf.viewModel.mapObjects! {
                        let pointAnnotation = PointAnnotation(organizationId: mapObject.organizationId, name: mapObject.name, type: mapObject.type, status: mapObject.status, phone:mapObject.phone, address: mapObject.address, coords: YMKMapCoordinate(latitude: mapObject.coords.latitude, longitude: mapObject.coords.longitude), clusterAnnotaions: mapObject.clusterAnnotaions)
                        
                        if strongSelf.filterMode {
                            strongSelf.mapView.addAnnotation(pointAnnotation)
                        } else {
                            strongSelf.allAnnotationsMapView.addAnnotation(pointAnnotation)
                        }
                    }
                    
                    if strongSelf.filterMode {
                        strongSelf.mapView.setRegion(strongSelf.viewModel.getSearchRegion(), animated: true)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                            strongSelf.updateMapObjects()
                        })
                    } else {
                        strongSelf.updateVisibleAnnotations()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel = MapViewModel()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Name(rawValue:"SHOW_CALLOUT_VIEW"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        let annotation = notification.userInfo?["annotation"] as! PointAnnotation
                        strongSelf.selectedMapObjectId = annotation.organizationId
                        strongSelf.calloutName.text = annotation.name
                        strongSelf.calloutAddress.attributedText  = DataManager.sharedInstance.highlightText(searchText: "Адрес:", inTargetText: "Адрес: \(annotation.address)", wthColor: UIColor.black)
                        strongSelf.calloutPhone.attributedText = annotation.phone.characters.count > 0 && !annotation.phone.contains("нет") ? DataManager.sharedInstance.highlightText(searchText: "Телефон:", inTargetText: "Телефон: \(annotation.phone)", wthColor: UIColor.black) : DataManager.sharedInstance.highlightText(searchText: "Телефон:", inTargetText: "Телефон: нет данных", wthColor: UIColor.black)
                        strongSelf.calloutCallButton.isHidden = annotation.phone.characters.count < 1 || annotation.phone.contains("нет")

                        strongSelf.favoriteButton.isSelected = DataManager.sharedInstance.isFavorite(kindergartenId: strongSelf.selectedMapObjectId)
                        strongSelf.favoritesLabel.text = strongSelf.favoriteButton.isSelected ? "Убрать из избранного" : "Добавить в избранное"
                        
                        strongSelf.calloutPhone.sizeToFit()
                        
                        strongSelf.calloutViewHeightConstraint.constant = strongSelf.calloutName.frame.size.height + strongSelf.calloutAddress.frame.size.height + strongSelf.calloutPhone.frame.size.height + 170
                        
                        strongSelf.calloutView.updateConstraintsIfNeeded()
                        strongSelf.view.layoutIfNeeded()
                        UIView.animate(withDuration: 0.5, animations: {
                            strongSelf.calloutViewBottomConstraint.constant = 80
                            strongSelf.view.layoutIfNeeded()
                        })
        }
        nc.addObserver(forName:Notification.Name(rawValue:"SET_REGION"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.searchIndicator.stopAnimating()
                        strongSelf.searchLabel.text = "Найдено объектов: 0"
                        let region = ((notification.userInfo?["region"] as! Array<MapSearchResult>).first)!
                        strongSelf.mapView.setCenter(YMKMapCoordinate(latitude: region.latitude, longitude: region.longitude), atZoomLevel: 12, animated: true)
        }
        nc.addObserver(forName:Notification.Name(rawValue:"ZOOM_IN"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        let annotation = notification.userInfo?["annotation"] as! PointAnnotation
                        strongSelf.mapView.setCenter(annotation.coords, atZoomLevel: strongSelf.mapView.zoomLevel+2, animated: true)
                        strongSelf.updateMapObjects()
        }
        nc.addObserver(forName:Notification.Name(rawValue:"HIDE_CALLOUT_VIEW"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.view.layoutIfNeeded()
                        UIView.animate(withDuration: 0.5, animations: {
                            strongSelf.calloutViewBottomConstraint.constant = -strongSelf.calloutView.frame.size.height - 80
                            strongSelf.view.layoutIfNeeded()
                        })
        }
        nc.addObserver(forName:Notification.Name(rawValue:"ADDRESS_DID_SELECT"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        let mapSearchResult = notification.userInfo?["mapSearchResult"] as! MapSearchResult
                        strongSelf.mapView.setCenter(CLLocationCoordinate2D(latitude: mapSearchResult.latitude, longitude: mapSearchResult.longitude), atZoomLevel: 14, animated: true)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: { 
                            strongSelf.updateMapObjects()
                        })
        }
        nc.addObserver(forName:Notification.Name(rawValue:"FILTER_ENABLED"),
                       object:nil, queue:nil) { [weak self] notification in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.mapView.removeAnnotations(strongSelf.mapView.annotations)
                        strongSelf.filterMode = true
                        strongSelf.searchResultView.isHidden = false
                        strongSelf.searchLabel.text = "Идет поиск объектов"
                        strongSelf.searchIndicator.startAnimating()
                        strongSelf.view.bringSubview(toFront: strongSelf.searchResultView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        searchController?.isActive = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView() {
        navigationController?.isNavigationBarHidden = true
        
        mapView.showsUserLocation = false;
        mapView.showTraffic = false;
        mapView.delegate = self;
        mapView.isBeingRotatedByUser = false;
        
        infographicsButton.layer.cornerRadius = 20
        infographicsButton.layer.masksToBounds = true
        
        searchKindergartenButton.layer.cornerRadius = 24
        searchKindergartenButton.layer.masksToBounds = true
        
        getToQueueButton.layer.cornerRadius = 20
        getToQueueButton.layer.masksToBounds = true
        
        calloutView.layer.cornerRadius = 4.0
        calloutView.layer.masksToBounds = false;
        calloutView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        calloutView.layer.shadowRadius = 6.0;
        calloutView.layer.shadowOpacity = 0.5;
        
        bottomView.layer.masksToBounds = false;
        bottomView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        bottomView.layer.shadowRadius = 5.0;
        bottomView.layer.shadowOpacity = 0.5;
        
        searchResultView.layer.cornerRadius = 4.0
        searchResultView.layer.masksToBounds = false;
        searchResultView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        searchResultView.layer.shadowRadius = 6.0;
        searchResultView.layer.shadowOpacity = 0.5;
        
        if !filterMode {
            setupSearchController()
        }
        
        if !UserDefaults.standard.bool(forKey: "WELCOME") {
            self.performSegue(withIdentifier: "Welcome View Segue", sender: nil)
            UserDefaults.standard.set(true, forKey: "WELCOME")
        }
    }

    func setupSearchController() {
        if searchController == nil {
            let searchResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewControllerID")
            searchController = CustomSearchController(searchResultsController: searchResultViewController)
            searchController?.searchResultsUpdater = searchResultViewController as? UISearchResultsUpdating
            searchController?.delegate = self
            searchController?.dimsBackgroundDuringPresentation = false
            searchController?.definesPresentationContext = true
            
            searchController?.searchBar.placeholder = "Поиск детского сада по адресу"
            searchController?.searchBar.delegate = self
            
            let width = UIScreen.main.bounds.size.width*0.9
            let searchBarView = UIView(frame: CGRect(x: self.view.frame.size.width/2-width/2, y: 30, width: width, height: 45))
            searchBarView.isOpaque = true
            searchBarView.backgroundColor = .white
            searchBarView.layer.cornerRadius = 8.0
            searchBarView.dropShadow()
            searchBarView.addSubview((searchController?.searchBar)!)
            
            self.view.addSubview(searchBarView)
            self.view.bringSubview(toFront: searchBarView)
        } else {
            searchController?.isActive = true
        }
    }
    
    func makeClusterImageWithNum(num: String) -> UIImage {
        let image = UIImage(named: "ClusterCircle")
        
        let textColor = UIColor(red: 0, green: 128.0/255.0, blue: 1, alpha: 1)
        let textFont = UIFont(name: "Helvetica", size: 14)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions((image?.size)!, false, scale)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let textFontAttributes = [
            NSFontAttributeName: textFont!,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: style
            ] as [String : Any]
        
        image?.draw(in: CGRect(origin: CGPoint.zero, size: (image?.size)!))
        
        var textSize = (image?.size)!
        textSize.height /= 2
        
        let rect = CGRect(x: 0, y: textSize.height/1.8, width: textSize.width, height: textSize.height)
        
        num.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func didDragMap(_ sender: UIGestureRecognizer) {
        if filterMode {
            NotificationCenter.default.post(name:Notification.Name(rawValue:"HIDE_CALLOUT_VIEW"),
                                            object: nil,
                                            userInfo: nil)
        }
        
        self.searchController?.searchBar.resignFirstResponder()
        
        if self.mapView.zoomLevel < 12 && !filterMode {
            self.mapView.setCenter(self.mapView.centerCoordinate, atZoomLevel: 12, animated: true)
        }
        
        if sender.state == .ended {
            print("ZOOOOOM: \(self.mapView.zoomLevel)")
            updateMapObjects()
        }
    }
    
    func updateMapObjects() {
        if !loading && !filterMode {
            UserDefaults.standard.removeObject(forKey: "SELECTED_REGION")
            let coordsTopLeft = CLLocationCoordinate2D(latitude: mapView.viewPort.mapRect.topLeft.latitude, longitude: mapView.viewPort.mapRect.topLeft.longitude)
            let coordsBottomRight = CLLocationCoordinate2D(latitude: mapView.viewPort.mapRect.bottomRight.latitude, longitude: mapView.viewPort.mapRect.bottomRight.longitude)
            let coordsArray = [coordsTopLeft, coordsBottomRight]
            
            loading = true
            
            self.viewModel.getMapObjects(with: coordsArray)
        }
        if filterMode {
            updateVisibleAnnotations()
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        searchController?.isActive = false
        
        NotificationCenter.default.post(name:Notification.Name(rawValue:"HIDE_CALLOUT_VIEW"),
                object: nil,
                userInfo: nil)
        
        if segue.identifier == "Kindergarten Segue" {
            if let viewController = segue.destination as? KindergartenTableViewController {
                viewController.viewmodel = KindergartenViewModel(kindergarten: DataManager.sharedInstance.kindergartenById(id: selectedMapObjectId)!)
            }
        }
    }
    
    // MARK: - UI Actions
    
    @IBAction func locateMeAction(_ sender: Any) {
        self.mapView.setCenter(self.viewModel.getCurrentLocation(), atZoomLevel: 14, animated: true)
        updateMapObjects()
    }
    
    @IBAction func zoomInAction(_ sender: Any) {
        mapView.zoomIn()
        updateMapObjects()
    }
    
    @IBAction func zoomOutAction(_ sender: Any) {
        if self.mapView.zoomLevel > 12 {
            mapView.zoomOut()
            updateMapObjects()
        }
    }
    
    @IBAction func makeCall(_ sender: Any) {
        if (calloutPhone.text?.characters.count)! > 0 {
            let phone = calloutPhone.text?.replacingOccurrences(of: "Телефон: ", with: "")
            DataManager.sharedInstance.makeCall(to: phone!)
        }
    }
    
    @IBAction func updateFavorites(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        DataManager.sharedInstance.updateFavorites(kindergartenId: selectedMapObjectId, remove: !sender.isSelected)
        favoritesLabel.text = favoriteButton.isSelected ? "Убрать из избранного" : "Добавить в избранное"
    }
    
    @IBAction func cancelFilterAction(_ sender: Any) {
        filterMode = false
        loading = false
        searchResultView.isHidden = true
        self.mapView.removeAnnotations(self.mapView.annotations)
        updateMapObjects()
    }
    
    @IBAction func showWelcomeView(_ sender: Any) {
        self.performSegue(withIdentifier: "Welcome View Segue", sender: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchController?.searchResultsUpdater?.updateSearchResults(for: searchController!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchControllerDelegate
    
    // MARK: - YMK
    
    func locateMeWithCoords(coords: CLLocationCoordinate2D, animated: Bool) {
        let pointAnnotation = PointAnnotation(organizationId: "0", name: "UserLocation", type: 0, status: 0, phone: "", address: "", coords: coords, clusterAnnotaions: nil)
        self.mapView.addAnnotation(pointAnnotation)
        
        if animated {
            self.mapView.setCenter(coords, atZoomLevel: 14, animated: true)
        }
    }
    
    func updateVisibleAnnotations() {
        if filterMode {
            self.viewModel.visibleMapObjects?.removeAll()
        }
        
        let gridSizeX = self.mapView.zoomLevel < 13 ? 4 : 6
        let gridSizeY = self.mapView.zoomLevel < 13 ? 6 : 12
        
        let visibleMapRect = self.mapView.viewPort.mapRect
        
        let deltaLon = (visibleMapRect.bottomRight.longitude - visibleMapRect.topLeft.longitude) / Double(gridSizeX)
        let deltaLat = (visibleMapRect.topLeft.latitude - visibleMapRect.bottomRight.latitude) / Double(gridSizeY)
        
        var topLeft = CLLocationCoordinate2D(latitude: visibleMapRect.topLeft.latitude, longitude: visibleMapRect.topLeft.longitude)
        var bottomRight = CLLocationCoordinate2D(latitude: visibleMapRect.topLeft.latitude - deltaLat, longitude: visibleMapRect.topLeft.longitude + deltaLon)
        
        for _ in 1 ... gridSizeY {
            
            for _ in 1 ... gridSizeX {
                
                let topLeftCoord = topLeft
                let bottomRightCoord = bottomRight
                let gridMapRect = YMKMapRect(topLeft: topLeftCoord, bottomRight: bottomRightCoord)
                
                self.viewModel.updateVisibleAnnotationsInMapRect(rect: gridMapRect)
                
                topLeft.longitude += deltaLon
                bottomRight.longitude += deltaLon
                
            }
            
            topLeft.latitude -= deltaLat
            topLeft.longitude = visibleMapRect.topLeft.longitude
            bottomRight.latitude -= deltaLat
            bottomRight.longitude = visibleMapRect.topLeft.longitude + deltaLon
            
        }
        
        if filterMode {
            //DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.locateMeWithCoords(coords: self.viewModel.getCurrentLocation(), animated: false)
                
                for mapObject in self.viewModel.visibleMapObjects! {
                    let pointAnnotation = PointAnnotation(organizationId: mapObject.organizationId, name: mapObject.name, type: mapObject.type, status: mapObject.status, phone:mapObject.phone, address: mapObject.address, coords: YMKMapCoordinate(latitude: mapObject.coords.latitude, longitude: mapObject.coords.longitude), clusterAnnotaions: mapObject.clusterAnnotaions)
                    
                    self.mapView.addAnnotation(pointAnnotation)
                }
            //}
        } else {
            //DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.locateMeWithCoords(coords: self.viewModel.getCurrentLocation(), animated: false)
                
                for mapObject in self.viewModel.visibleMapObjects! {
                    let pointAnnotation = PointAnnotation(organizationId: mapObject.organizationId, name: mapObject.name, type: mapObject.type, status: mapObject.status, phone:mapObject.phone, address: mapObject.address, coords: YMKMapCoordinate(latitude: mapObject.coords.latitude, longitude: mapObject.coords.longitude), clusterAnnotaions: mapObject.clusterAnnotaions)
                    
                    self.mapView.addAnnotation(pointAnnotation)
                }
            
            //}
        }
        
    }
    
    func mapView(_ mapView: YMKMapView!, viewFor annotation: YMKAnnotation!) -> YMKAnnotationView! {
        let identifier = "pointAnnotation"
        
        var view: CustomPinAnnotationView?
        
        view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomPinAnnotationView
        if view == nil {
            view = CustomPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        let pointAnnotation = annotation as! PointAnnotation
        
        if pointAnnotation.type == 0 {
            view?.image = UIImage(named: "UserLocation")
        } else if (pointAnnotation.type == -1) {
            view?.image = makeClusterImageWithNum(num: "\(pointAnnotation.clusterAnnotaions!.count)")
        } else {
            if pointAnnotation.status > 0 {
                if pointAnnotation.status == 1 {
                    if pointAnnotation.type == 3 || pointAnnotation.type == 4 || pointAnnotation.type == 5 || pointAnnotation.type == 6 {
                        view?.image = UIImage(named: "BlueIcon")
                        view?.selectedImage = UIImage(named: "activeblue")
                    } else if pointAnnotation.type == 1 || pointAnnotation.type == 2 || pointAnnotation.type == 7 {
                        view?.image = UIImage(named: "RedIcon")
                        view?.selectedImage = UIImage(named: "activered")
                    }
                } else if pointAnnotation.status == 2 || pointAnnotation.status == 3 || pointAnnotation.status == 4 || pointAnnotation.status == 5 || pointAnnotation.status == 6 {
                    view?.image = UIImage(named: "GreyIcon")
                    view?.selectedImage = UIImage(named: "activegrey")
                }
            }
        }
        
        view?.annotation = pointAnnotation
        view?.animatesDrop = false
        
        return view
    }
    
}

