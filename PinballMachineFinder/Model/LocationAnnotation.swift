//
//  LocationAnnotation.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 8/9/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    var location: Location
    var coordinate: CLLocationCoordinate2D
    
    var locationId: Int? {
        return location.id
    }
    var locationName: String? {
        return location.name
    }
    var street: String? {
        return location.street
    }
    var city: String? {
        return location.city
    }
    var state: String? {
        return location.state
    }
    var zip: String? {
        return location.zip
    }
    var latitude: String? {
        return location.lat
    }
    var longitude: String? {
        return location.lon
    }
    var website: String? {
        return location.website
    }
    //    var numberOfMachines: Int? {
    //        return location.numberOfMachines
    //    }
    init(coordinate: CLLocationCoordinate2D, location: Location) {
        self.coordinate = coordinate
        self.location = location
    }
}
