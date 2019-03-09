//
//  LocationController.swift
//  PinballMachineFinder
//
//  Created by Joshua Danner on 8/1/18.
//  Copyright © 2018 JoshuaDanner. All rights reserved.
//

import Foundation
import UIKit

class LocationController {
    
    static var sharedInstance = LocationController()
    
    var regions: [Region] = []
    var locations: [Location] = []
    var machines: [Machine] = []
    
    fileprivate var regionURL = URL(string: "https://pinballmap.com/api/v1/regions.json")
    fileprivate var baseLocationURL = URL(string: "https://pinballmap.com/api/v1/region/")
    fileprivate var baseMachinesAtLocationURL = URL(string: "https://pinballmap.com/api/v1/locations/")
    
    // Fetch list of available regions to access name for Location Fetch
    func fetchRegions(completion: @escaping(Bool) -> Void) {
        
        guard let regionURL = regionURL?.absoluteURL else { completion(true) ; return }
        print("📡📡📡 \(regionURL) 📡📡📡")
        
        var request = URLRequest(url: regionURL)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("❌ Error with dataTask fetching: \(error.localizedDescription)")
                completion(false)
                return
            }
            guard let data = data else { completion(true) ; return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let topLevel = try jsonDecoder.decode(TopLevelRegion.self, from: data)
                var regions = topLevel.regions.compactMap({$0})
                self.regions = regions
                completion(true)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Missing key: \(key)")
                print("Debug description: \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                
                
            } catch let error {
                print("❌Error decoding movie data. Exiting with error: \(error)")
                completion(false)
                return
                
            }
            }.resume()
        
    }
    
    func fetchLocationsWith(region: String, completion: @escaping([Location]?) -> Void) {
        
        guard let url = baseLocationURL else { completion(nil) ; return }
        
        let completeLocationURL = url.appendingPathComponent(region).appendingPathComponent("locations").appendingPathExtension("json")
        
        print("📡📡📡 \(completeLocationURL) 📡📡📡")
        
        URLSession.shared.dataTask(with: completeLocationURL) { (data, _, error) in
            if let error = error {
                print("❌Error downloading locations with DataTask: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil) ; return }
            
            let jsonDecoder = JSONDecoder()
            do {
                let locations = try jsonDecoder.decode(TopLayer.self , from: data).locations
                self.locations = locations
                completion(self.locations)
            } catch let error {
                
                print("Error decoding location from dataTask: \(error)")
                completion(nil)
                return
            }
            // print(data)
            }.resume()
    }
    
    //-----------------------------------
    
    func fetchMachinesWith(location: Int, completion: @escaping([Machine]?) -> Void) {
        
        guard let url = baseMachinesAtLocationURL else { completion(nil) ; return }
        
        let completeMachinesAtLocation = url.appendingPathComponent("\(location)").appendingPathComponent("machine_details").appendingPathExtension("json")
        
        print("📡📡📡 \(completeMachinesAtLocation) 📡📡📡📡📡📡📡📡📡📡📡📡")
        
        URLSession.shared.dataTask(with: completeMachinesAtLocation) { (data, _, error) in
            
            if let error = error {
                print("Error downloading machineIDs with DataTask: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil) ; return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let topLevelMachines = try jsonDecoder.decode(TopLevelMachineLocation.self , from: data)
                let machines = topLevelMachines.machines.compactMap({$0})
                self.machines = machines
                completion(machines)
            } catch let error {
                print("Error decoding location from dataTask: \(error)")
                completion(nil)
                return
            }
            print(data)
            }.resume()
    }
    
    func fetchPinballMachinesWithin(latitude: String, longitude: String, completion: @escaping([Location]?) -> Void) {
        let baseUrl = URL(string: "https://pinballmap.com/api/v1/locations/closest_by_lat_lon.json")!
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        let coordinatesQuery = URLQueryItem(name: "lat", value: "\(latitude)&lon=\(longitude)")
        components?.queryItems = [coordinatesQuery]
        
        guard var locationUrl = components?.url?.absoluteString else {
            return
        }
        
        let distanceParameters = "&send_all_within_distance=true&max_distance=25" // Shows all pinball locations witin a 50 mile radius of latitude and longitude.
        
        locationUrl += distanceParameters
        
        let completeUrl = URL(string: locationUrl.replacingOccurrences(of: "%26", with: "&").replacingOccurrences(of: "%3D", with: "="))!
        // TODO: See if you can implement percent encoding to clean up this url
        
        URLSession.shared.dataTask(with: completeUrl) { (data, _, error) in
            if let error = error {
                print("Datatask could not reach the network with the url: \(completeUrl). \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let pinballMachines = try jsonDecoder.decode(TopLayer.self, from: data).locations
                self.locations = pinballMachines
                completion(self.locations)
            } catch {
                assertionFailure("Error decoding json into data. \(error.localizedDescription)")
            }
            }.resume()
    }
    
} // End LocationController








