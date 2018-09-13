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

class LocationsViewController: UIViewController {
    
    // MARK: - Properties
    
    var navigationButton = UIButton()
    private let locationController = LocationController()
    
    var regionNames: [Region] = []
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    var selectedAnnotation: MKPointAnnotation?
    
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
        
        fetchRegion()
        tableViewDelegates()
        navigationTitleButtonProperties()
        
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
                   self.locationTableView.reloadData()
                }
            }
        }
        
    }
    
    // Functions for finding the users location
    
//    // 1 Authorization for user to access maps --------------------------------------------------
//    func configureLocationServices() {
//        locationManager.delegate = self
//
//        let status = CLLocationManager.authorizationStatus()
//
//        if status == .restricted ||
//            status == .denied ||
//            status == .notDetermined {
//            locationManager.requestWhenInUseAuthorization()
//        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
//            beginLocationUpdates(locationManager: locationManager)
//        }
//    }
//
//    // 2 Function for giving the desired user's location
//    func beginLocationUpdates(locationManager: CLLocationManager) {
//        locationsMapView.showsUserLocation = true
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
//    }
//
//    // 3 Function for zooming into user's location
//
//    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
//        let zoomRegion = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000)
//        locationsMapView.setRegion(zoomRegion, animated: true)
//    }
//
//    // 4 Function for giving the annotation for users's location
//
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        self.selectedAnnotation = view.annotation as? MKPointAnnotation
//    }
//
//
//
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

//extension LocationsViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let latestLocation = locations.first else { return }
//
//        if currentCoordinate == nil {
//            zoomToLatestLocation(with: latestLocation.coordinate)
//
//        }
//
//        currentCoordinate = latestLocation.coordinate
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("The status changed my friend the status changed")
//
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            beginLocationUpdates(locationManager: manager)
//        }
//    }
//}
// MARK: - TableViewDelegates

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Returns count of items in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == self.popupTableView {
            let  count = LocationController.sharedInstance.regions.count
            print("🍎 \(count)")
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
            print("🍉 \(count)")
            return count
            
        }
        return count!
    }
    
    // Select item from tableView
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.popupTableView {
            
            guard let regionLocationFullName = LocationController.sharedInstance.regions[indexPath.row].regionLocationFullName else { return }
            navigationButton.setTitle("\(regionLocationFullName) ▾", for: .normal)
            popupViewCenterYAxis.constant = -1000
            
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
                self.backgroundButton.alpha = 0
            }
            guard let regionLocationName = LocationController.sharedInstance.regions[indexPath.row].regionLocationName else { return }
            locationController.fetchLocationsWith(region: regionLocationName) { (locations) in // Jaydens contribution
                guard let locations = locations else { print("Couldn't get location") ; return }
                LocationController.sharedInstance.locations = locations
                
                DispatchQueue.main.async {
                    self.locationTableView.reloadData()
                }
                
                locations.forEach {
                    print($0.city ?? "No Data")
                    
                }
            }
        }
        
        if tableView == self.locationTableView {
            guard let regionLocationFullName = LocationController.sharedInstance.regions[indexPath.row].regionLocationFullName else { return }
            locationController.fetchLocationsWith(region: regionLocationFullName) { (locations) in // Jaydens contribution
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
            
            return cell ?? UITableViewCell()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toLocationsVC" {
            guard let destinationVC = segue.destination as? LocationsMachinesViewController,
                let indexPath = locationTableView.indexPathForSelectedRow else { return }
            
            let location = LocationController.sharedInstance.locations[indexPath.row]
            
            destinationVC.location = location
            
            
        
            
            
        }
    }
}





