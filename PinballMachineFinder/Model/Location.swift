//
//  Location.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 8/1/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//
// ----- Todays the day to say hurray! ----------------------
import Foundation
import MapKit

struct TopLayer: Codable {
    let locations: [Location]
}

struct Location: Codable {
    let id: Int?
    let name, street, city: String?
    let state: String?
    let zip: String?
    let phone: String?
    let lat: String?
    let lon: String?
    let website: String?
    let dateLastUpdated: String?
    let distance: Double?
    let machineName: [String]?
    let machineId: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, street, city, state, zip, phone, lat, lon, website, distance
        case dateLastUpdated = "date_last_updated"
        case machineName = "machine_names"
        case machineId = "machine_ids"
    }
}


//struct TopLevelLocation: Codable {
//    let locations: [Location]
//}
//
//
//// This is my object
//class Location: NSObject, Codable {
//
//    var coordinate: Coordinate?
//    let locationID: Int?
//    let locationName: String?
//    let street: String?
//    let city: String?
//    let state: String?
//    let zip: String?
//    let latitude: String?
//    let longitude: String?
//    let website: String?
//    let numberOfMachines: Int?
//    let machineXRefs: [MachineXRef]
//
//
//
//
//    init(locationID: Int?, locationName: String?, street: String?, city: String?, state: String?, zip: String?, latitude: String?, longitude: String?, website: String?, numberOfMachines: Int, machineXRefs: [MachineXRef]) {
//        self.locationID = locationID
//        self.locationName = locationName
//        self.street = street
//        self.city = city
//        self.state = state
//        self.zip = zip
//        self.latitude = latitude
//        self.longitude = longitude
//        self.website = website
//        self.numberOfMachines = numberOfMachines
//        self.machineXRefs = machineXRefs
//
//
//
//    }
//
//    private enum CodingKeys: String, CodingKey {
//        case locationID = "id"
//        case locationName = "name"
//        case latitude = "lat"
//        case longitude = "lon"
//        case street, city, state, zip, website
//        case numberOfMachines = "num_machines"
//        case machineXRefs = "location_machine_xrefs"
//        case coordinate = "coordinate"
//
//    }
//
//
//    struct Coordinate: Codable {
//        let lat: Double?
//        let long: Double?
//    }
//
//    public var newCoordinate: CLLocationCoordinate2D {
//        guard let longitude = coordinate?.long,
//            let latitude = coordinate?.lat
//            else { return  CLLocationCoordinate2D()}
//        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//    }
//
//}
//
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self,
                                       resolvingAgainstBaseURL: true)
        components?.queryItems = queries.compactMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}

//
//struct MachineXRef: Codable {
//
//    let locationID: Int?
//    let machineID: Int?
//
//    private enum CodingKeys: String, CodingKey {
//
//        case locationID = "location_id"
//        case machineID = "machine_id"
//
//    }
//}










