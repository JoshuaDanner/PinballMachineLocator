//
//  LocationsViewController.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 7/25/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Properties
    var navigationButton = UIButton()
    var regionNames: [Region] = []
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    let locationController = LocationController()
    var selectedAnnotation: MKPointAnnotation?
    
    // MARK: IBOutlets
    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewCenterYAxis: NSLayoutConstraint!
    @IBOutlet weak var popupTableView: UITableView!
    @IBOutlet weak var locationsMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupTableView.dataSource = self
        popupTableView.delegate = self
        popupTableView.register(UITableViewCell.self, forCellReuseIdentifier: "popoverCell")
        
        //popupViewProperties()
        navigationTitleButtonProperties()
        
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
        
        LocationController.sharedInstance.fetchRegions { (success) in
            if success {
               // print("Success for region!😀😀😀😀")
                self.popupTableView.reloadData() // Jaydens contribution to get it to load regularly.
                
            }
        }
        
    }
    
    func locationTableViewProperties() {

    }

    func popupViewProperties() {
//        let regionPopupView = RegionPopupView()
//        self.popupView.addSubview(regionPopupView)

    }
    
    func navigationTitleButtonProperties() {
        
        // Add Button to the NavigationBar
        self.navigationItem.titleView = navigationButton
        
        // Configure the button
       
        navigationButton.setTitle("Select Region ▾", for: .normal)
        navigationButton.setTitleColor(UIColor.black, for: .normal)
        navigationButton.addTarget(self, action: #selector(self.showRegionPopup), for: .touchUpInside)
        navigationButton.sizeToFit()
        navigationButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        navigationButton.widthAnchor.constraint(equalToConstant: 220).isActive = true
        navigationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        _ = locationController.fetchRegions { (success) in
            if success {
                DispatchQueue.main.async {
                    let regionName = LocationController.sharedInstance.regions.first?.regionLocationFullName
                    guard let nameToSearch = regionName else { return }
                    self.popupTableView.reloadData()
                }
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
    
    // 2 Function for giving the desired user's location
    func beginLocationUpdates(locationManager: CLLocationManager) {
        locationsMapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // 3 Function for zooming into user's location
    
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
        locationsMapView.setRegion(zoomRegion, animated: true)
    }
    
    // 4 Function for giving the annotation for users's location
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        self.selectedAnnotation = view.annotation as? MKPointAnnotation
    }
   // --------------------------------------------------------------------------------------------------------------



    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == self.popupTableView {
            count = self.locationController.regions.count
            print("🍎 \(count)")
        }
        if tableView == self.locationTableView {
            count = self.locationController.locations.count
            print("🍉 \(count)")
            
        }
        return count!
    }
    
    // Select item from tableView
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.popupTableView {
            
            guard let regionName = LocationController.sharedInstance.regions[indexPath.row].regionLocationFullName else { return }
            navigationButton.setTitle("\(regionName) ▾", for: .normal)
            popupViewCenterYAxis.constant = -630
            
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
                self.backgroundButton.alpha = 0
            }
            
           locationController.fetchLocationsWith(region: regionName) { (locations) in // Jaydens contribution
                guard let locations = locations else { print("Couldn't get location") ; return }
                locations.forEach {
                    print($0.city as Any)
                    
                }
            }
        } else {
            
            guard let locationName = LocationController.sharedInstance.locations[indexPath.row].locationName else { return }
            
//            let locationName = LocationController.sharedInstance.regions[indexPath.row].regionLocationName
//            print("😇This is the name that will be used for the location fetch function \(locationName)")
//
//            locationController.fetchLocationsWith(region: locationName!) { (success) in
//                DispatchQueue.main.async {
//                    self.locationTableView.reloadData()
   //             }
     //       }
        }
    }
    
    //Assign values for tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?

        if tableView == self.popupTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "popoverCell", for: indexPath)

            let regionName = LocationController.sharedInstance.regions[indexPath.row]
            cell?.textLabel?.text = regionName.regionLocationFullName
        }

        if tableView == self.locationTableView {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationsTableViewCell
            
            let location = locationController.locations[indexPath.row]
            cell.locations = location
            
            locationController.fetchLocationsWith(region: "\(location)") { (newLocation) in
                DispatchQueue.main.async {
                    cell.locationName.text = "\(String(describing: newLocation))"
                }
            }
        }
        return cell!
    }
    
    
    @IBAction func closePopUp(_ sender: Any) {
        popupViewCenterYAxis.constant = -630
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0
        }
    }
    
    @objc func showRegionPopup(navigationButton: UIButton) {
        
        popupViewCenterYAxis.constant = -73
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.1, animations: {
            self.view.layoutIfNeeded()
            self.backgroundButton.alpha = 0.5
        })
    }
    
    // MARK: IBActions
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
} // End of class my friend, end class.



// The Delegate my friend, the Delegate.........my friend.
extension LocationsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed my friend the status changed")
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}
