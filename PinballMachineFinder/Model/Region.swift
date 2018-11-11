//
//  Location.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 7/30/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import Foundation

struct TopLevelRegion: Codable {
    let regions: [Region]
}

// This is your object
struct Region : Codable {

    let regionLocationID: Int? // for url
    let regionLocationName: String?
    let regionLocationFullName: String? // Most likely for navigationBar

    enum CodingKeys: String, CodingKey {
        case regionLocationID = "id"
        case regionLocationName = "name"
        case regionLocationFullName = "full_name"

    }
}
