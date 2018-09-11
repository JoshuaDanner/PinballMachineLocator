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
    
   var navigationTitle = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitleProperties()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func navigationTitleProperties() {
        
       self.navigationItem.titleView = navigationTitle
       navigationTitle.text = "Scoops"
    }
    
    
} /// --------------------------------------------- end of class. Class is out








extension LocationsMachinesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "wackyTacky", for: indexPath)
        
        return cell
    }
}

