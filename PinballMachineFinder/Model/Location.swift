//
//  Location.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 8/1/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import Foundation
import MapKit

struct TopLevelLocation: Codable {
    let locations: [Location]
}


// This is your object
class Location: Codable {
    
    let locationID: Int?
    let locationName: String?
    let street: String?
    let city: String?
    let state: String?
    let zip: String?
    let latitude: String?
    let longitude: String?
    let website: String?
    let numberOfMachines: Int?
    
    init(locationID: Int?, locationName: String?, street: String?, city: String?, state: String?, zip: String?, lat: String?, lon: String?, website: String?, numberOfMachines: Int) {
        self.locationID = locationID
        self.locationName = locationName
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
        self.latitude = lat
        self.longitude = lon
        self.website = website
        self.numberOfMachines = numberOfMachines
    }
    
//    public var newCoordinate: CLLocationCoordinate2D {
//        guard let latitude = loc
//            else { return  CLLocationCoordinate2D()}
//        return CLLocationCoordinate2D(latitude: lat, longitude: longitude)
//    }
    
    struct Coordinate: Codable {
        let latitude: Double
        let longitude: Double
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case locationID = "id"
        case locationName = "name"
        case latitude = "lat"
        case longitude = "lon"
        case street, city, state, zip, website
        case numberOfMachines = "num_machines"
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}










