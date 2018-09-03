//
//  Machine.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 8/1/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import Foundation

// Top level
struct MachineXRef: Codable {
    let locationID: String?
    let machineID: String?
    let machineDetails: [Machine]
    
    // Nested level
    private enum CodingKeys: String, CodingKey {
        case locationID =  "location_id"
        case machineID = "machine_id"
        case machineDetails = "machine"
        
    }
    
    struct MachineDictionary: Codable {
        // This is a property to your object
        let machine: Machine
    }
}

// This is your actual object
struct Machine: Codable {
    let machineID: Int?
    let name: String?
    let IPDBLink: String?
    
    private enum CodingKeys: String, CodingKey {
        case machineID = "id"
        case name
        case IPDBLink = "ipdb_link"
    }
}
