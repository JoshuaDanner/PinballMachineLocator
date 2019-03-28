//
//  LocationsMachinesViewController.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 7/25/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import UIKit

class LocationsMachinesViewController: UIViewController {
    
    // MARK: - Properties
    private let locationController = LocationController()
    var navigationTitle = UILabel()
    var location: Location?
    var machine: Machine?
    
    @IBOutlet weak var machinesAtLocationTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationTitleProperties()
        tableViewDelegates()
        fetchMachinesAtLocation()
        
    }
    
    func navigationTitleProperties() {
        
        self.navigationItem.titleView = navigationTitle
        navigationTitle.text = location?.name
    }
    
    func tableViewDelegates() {
        machinesAtLocationTableView.delegate = self
        machinesAtLocationTableView.dataSource = self
    }
    
    func fetchMachinesAtLocation() {
        
        if let location = location {
            let machineIDString = location.id
            guard let machineID = machineIDString else { return }
            
            locationController.fetchMachinesWith(location: machineID) { (machine) in
                
                
                guard let machine = machine else { return }
                machine.forEach {
                    print($0.name ?? "NO DATA MY FRIEND")
                    
                }
                self.reloadTableView()
            }
        }
    }
    
    func reloadTableView() {
        
        DispatchQueue.main.async {
            self.machinesAtLocationTableView.reloadData()
        }
    }
    
    
} /// --------------------------------------------- end of class. Class is out


extension LocationsMachinesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        func refresh(sender: UIRefreshControl?) {
            if locationController.machines.count > 0 {
                self.machinesAtLocationTableView.reloadData()
                sender?.endRefreshing()
            } else {
                sender?.endRefreshing()
            }
        }
        return locationController.machines.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = machinesAtLocationTableView.dequeueReusableCell(withIdentifier: "locationsMachineCell", for: indexPath) as? LocationsMachinesTableViewCell
        let locationsMachines = locationController.machines[indexPath.row]
        cell?.machine = locationsMachines
        
        if indexPath.row % 3 == 0 {
            let blueColor = UIColor(red:0.44, green:0.56, blue:0.69, alpha:1.0)
            cell?.backgroundColor = blueColor
            
        } else if indexPath.row % 2 == 0 {
            let redColor = UIColor(red:0.84, green:0.42, blue:0.47, alpha:1.0)
            cell?.backgroundColor = redColor
            
        } else {
            let greenColor = UIColor(red:0.67, green:0.78, blue:0.50, alpha:1.0)
            cell?.backgroundColor = greenColor
        }
        //let rectangleImageView = UIImage(named: "RectangleBlue")
        
        print(locationsMachines)
        
        return cell ?? UITableViewCell()
    }
}

