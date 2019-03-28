//
//  LocationsViewController.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 7/25/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import UIKit
import MapKit

class LocationsViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: - Properties
    var navigationButton = UIButton()
    
    var locations: [Location] = []
    var foundPinballMachines: [Location] = []
    
    var regionNames: [Region] = []
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    var selectedAnnotation: MKPointAnnotation?
    var selectedLocation: Location?
    
    
    let calloutNib = Bundle.main.loadNibNamed("CalloutView", owner: nil, options: nil)
    lazy var calloutView = calloutNib?.first as! CalloutView
    
    let annotationButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAnnotationButtonTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: IBOutlets
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var popupViewCenterYAxis: NSLayoutConstraint!
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var locationsMapView: MKMapView!
    
    
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsMapView.delegate = self
        locationsMapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMapInteraction)))
        configureLocationServices()
        fetchRegion()
        tableViewDelegates()
        navigationTitleButtonProperties()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let currentCoordinate = currentCoordinate else { return }
        
        locationsMapView.setRegion(MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        
        // ^^^^ This code will reset the map view everytime the view appears. When you navigate back from the detail view controller, the map will refocus back to wherever the user is located. This may not be the behavior I want when using the drop down menu to discover other cities with pinball machines.
        
    }
    
    
    
    let regionRadius: CLLocationDistance = 10000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        locationsMapView.setRegion(coordinateRegion, animated: true)
    }
    
    func fetchRegion() {
        LocationController.sharedInstance.fetchRegions { (success) in
            if success {
                DispatchQueue.main.async {
                    self.popupTableView.reloadData() // Jaydens contribution to get it to load regularly.
                }
            }
        }
    }
    
    func tableViewDelegates() {
        popupTableView.dataSource = self
        popupTableView.delegate = self
        popupTableView.register(UITableViewCell.self, forCellReuseIdentifier: "popoverCell")
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
    }
    
    func locationTableViewProperties() {
        
    }
    
    func popupViewProperties() {
        
    }
    
    func navigationTitleButtonProperties() {
        
        // Add Button to the NavigationBar
        self.navigationItem.titleView = navigationButton
        
        // Configure the button
        
        navigationButton.setTitle("          Select Region ▾          ", for: .normal)
        navigationButton.setTitleColor(UIColor.black, for: .normal)
        navigationButton.addTarget(self, action: #selector(self.showRegionPopup), for: .touchUpInside)
        navigationButton.sizeToFit()
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        navigationButton.widthAnchor.constraint(equalToConstant: 220).isActive = false
        navigationButton.heightAnchor.constraint(equalToConstant: 40).isActive = false
    }
    
    func fetchPinballMachinesWithin(latitude: String, longitude: String) {
        LocationController.sharedInstance.fetchPinballMachinesWithin(latitude: latitude, longitude: longitude) { (machines) in
            if let machines = machines {
                self.foundPinballMachines = machines
                self.populateMapWithPinballMachines()
            }
        }
    }
    
    func populateMapWithPinballMachines() {
        removeMapAnnotations()
        
        for pinballMachine in foundPinballMachines {
            guard let latitude = pinballMachine.lat,
                let longitude = pinballMachine.lon else {
                    return
            }
            
            DispatchQueue.main.async {
                let pointAnnotation = LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude) ?? 0, longitude: CLLocationDegrees(longitude) ?? 0), location: pinballMachine)
                
                self.locationsMapView.addAnnotation(pointAnnotation)
            }
        }
    }
    
    // Functions for finding the users location
    
    // 1 Authorization for user to access maps --------------------------------------------------
    func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .restricted ||
            status == .denied ||
            status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    // 2 Function for giving the user's location
    func beginLocationUpdates(locationManager: CLLocationManager) {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // 3 Function for zooming into user's location
    
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        locationsMapView.setRegion(zoomRegion, animated: true)
    }
    
    // 4 Function for giving the annotation for users's location
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let calloutViewReuseIdentifier = "calloutView"
        
        var annotationView = locationsMapView.dequeueReusableAnnotationView(withIdentifier: calloutViewReuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: calloutViewReuseIdentifier)
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "pin")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        
        guard let locationAnnotation = view.annotation as? LocationAnnotation else {
            assertionFailure("Location annotation could not be loaded")
            return
        }
        
        calloutView.addSubview(annotationButton)
        calloutView.bringSubviewToFront(annotationButton)
        annotationButton.translatesAutoresizingMaskIntoConstraints = false
        annotationButton.centerXAnchor.constraint(equalTo: calloutView.centerXAnchor).isActive = true
        annotationButton.centerYAnchor.constraint(equalTo: calloutView.centerYAnchor).isActive = true
        annotationButton.widthAnchor.constraint(equalTo: calloutView.widthAnchor).isActive = true
        annotationButton.heightAnchor.constraint(equalTo: calloutView.heightAnchor).isActive = true
        
        calloutView.pinballLocation = locationAnnotation.location
        
        selectedLocation = locationAnnotation.location
        
        DispatchQueue.main.async {
            if let coordinate = view.annotation?.coordinate {
                self.locationsMapView.addSubview(self.calloutView)
                self.locationsMapView.setCenter(coordinate, animated: true)
                
                // TODO: I'd mess around with the constraints a bit more to get it where you want it.
                self.calloutView.center = CGPoint(x: self.locationsMapView.center.x, y: self.locationsMapView.center.y * 0.60)
            }
        }
    }
    
    func removeMapAnnotations() {
        DispatchQueue.main.async {
            self.locationsMapView.removeAnnotations(self.locationsMapView.annotations)
        }
    }
    
    func removeCalloutView() {
        if self.calloutView.isDescendant(of: self.locationsMapView) {
            self.calloutView.removeFromSuperview()
        }
    }
    
    @objc func handleAnnotationButtonTap() {
        self.performSegue(withIdentifier: "toLocationsVC", sender: self)
    }
    
    @objc func handleMapInteraction() {
        // Close callout view if user taps outside of callout view and not on annother annotation
        removeCalloutView()
    }
    
    @objc func showRegionPopup(navigationButton: UIButton) {
        
        popupViewCenterYAxis.constant = -53
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
        })
    }
    
    // MARK: IBActions
    @IBAction func closePopUp(_ sender: Any) {
        popupViewCenterYAxis.constant = -1000
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        }
    }
} // ------------------End of class my friend, end class.



// The MapKit Delegate my friend, the MapKit Delegate.........my friend.

extension LocationsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }
        
        currentCoordinate = latestLocation.coordinate
        
        let latitude = String(latestLocation.coordinate.latitude)
        let longitude = String(latestLocation.coordinate.longitude)
        
        fetchPinballMachinesWithin(latitude: latitude, longitude: longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed my friend the status changed")
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}
// MARK: - TableViewDelegates

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == self.popupTableView {
            let  count = LocationController.sharedInstance.regions.count
            
            return count
        }
        if tableView == self.locationTableView {
            let count = LocationController.sharedInstance.locations.count
            func refresh(sender: UIRefreshControl?) {
                if count > 0 {
                    self.locationTableView.reloadData()
                    sender?.endRefreshing()
                } else {
                    sender?.endRefreshing()
                }
            }
            
            return count
            
        }
        return count!
    }
    
    // Select item from tableView
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.removeMapAnnotations() // Remove current annontations before adding new ones.
        self.removeCalloutView()
        
        if tableView == self.popupTableView {
            
            guard let regionLocationFullName = LocationController.sharedInstance.regions[indexPath.row].regionLocationFullName else { return }
            navigationButton.setTitle("\(regionLocationFullName) ▾", for: .normal)
            popupViewCenterYAxis.constant = -1000
            
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
                self.backgroundButton.alpha = 0
            }
            guard let regionLocationName = LocationController.sharedInstance.regions[indexPath.row].regionLocationName else { return }
            LocationController.sharedInstance.fetchLocationsWith(region: regionLocationName) { (locations) in
                guard let locations = locations else { print("Couldn't get location") ; return }
                //                LocationController.sharedInstance.locations = locations
                
                self.locations = locations
                
                DispatchQueue.main.async {
                    for location in locations {
                        guard let latitude = location.lat,
                            let longitude = location.lon else {
                                return
                        }
                        let degreesLatitude = CLLocationDegrees(latitude) ?? 0
                        let degreesLongitude = CLLocationDegrees(longitude) ?? 0
                        let regionCoordinates = CLLocationCoordinate2D(latitude: degreesLatitude, longitude: degreesLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                        let region = MKCoordinateRegion(center: regionCoordinates, span: span)
                        let annotation = LocationAnnotation(coordinate: regionCoordinates, location: location)
                        
                        self.locationsMapView.addAnnotation(annotation)
                        self.locationsMapView.setRegion(region, animated: true)
                    }
                    self.locationTableView.reloadData()
                }
                
                locations.forEach {
                    print($0.city ?? "No Data")
                    
                }
            }
        }
        
        if tableView == self.locationTableView {
            guard let regionLocationFullName = LocationController.sharedInstance.regions[indexPath.row].regionLocationFullName else { return }
            LocationController.sharedInstance.fetchLocationsWith(region: regionLocationFullName) { (locations) in
                guard let locations = locations else { print("Couldn't get location") ; return }
                LocationController.sharedInstance.locations = locations
                //self.locationTableView.reloadData()
                
                locations.forEach {
                    print($0.city ?? "No Data")
                    
                }
            }
        }
    }
    //Assign values for tableView
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == popupTableView {
            
            let cell = popupTableView.dequeueReusableCell(withIdentifier: "popoverCell", for: indexPath)
            
            let regionName = LocationController.sharedInstance.regions[indexPath.row]
            
            cell.textLabel?.text = regionName.regionLocationFullName
            //self.locationTableView.reloadData()
            return cell
            
        } else {
            
            let cell = locationTableView.dequeueReusableCell(withIdentifier: "locationsCelly", for: indexPath) as? LocationsTableViewCell
            let locationsInRegion = LocationController.sharedInstance.locations[indexPath.row]
            cell?.location = locationsInRegion
            
            //            if indexPath.row % 2 == 0 {
            //                cell?.backgroundColor = UIColor.lightGray
            //                //cell?.cellColorImage = UIImageView(named: "RectangleBlue")!
            //            } else {
            //                cell?.backgroundColor = UIColor.white
            //
            //            }
            //let rectangleImageView = UIImage(named: "RectangleBlue")
            
            
            return cell ?? UITableViewCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        popupTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toLocationsVC" {
            guard let destinationVC = segue.destination as? LocationsMachinesViewController else { return }
            
            if let indexPath = locationTableView.indexPathForSelectedRow {
                // Segue from table view
                let location = locations[indexPath.row]
                destinationVC.location = location
            } else {
                // Segue from an annotation
                destinationVC.location = selectedLocation
            }
        }
    }
}





