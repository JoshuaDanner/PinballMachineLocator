//
//  CalloutView.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 3/9/19.
//  Copyright © 2019 JoshuaDanner. All rights reserved.
//

import UIKit

class CalloutView: UIView {
    
    var pinballLocation: Location? {
        didSet {
            if let location = pinballLocation {
                self.locationNameLabel.text = location.name
            }
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var locationNameLabel: UILabel!
}
