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
        navigationTitle.text = location?.locationName
    }

    func tableViewDelegates() {
        machinesAtLocationTableView.delegate = self
        machinesAtLocationTableView.dataSource = self
    }

    func fetchMachinesAtLocation() {

        if let location = location {
            let machineIDString = location.locationID
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

        print(locationsMachines)

        return cell ?? UITableViewCell()

    }
}

