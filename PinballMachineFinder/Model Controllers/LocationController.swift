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
    
    var regionURL = URL(string: "https://pinballmap.com/api/v1/regions.json")
    var baseLocationURL = URL(string: "https://pinballmap.com/api/v1/region/")
    
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
                let regions = topLevel.regions.compactMap({$0})
                self.regions = regions
                completion(true)
                
            } catch let error {
                print("❌Error decoding movie data. Exiting with error: \(error)")
                completion(false)
                return
                
            }
            }.resume()
        
    }
    
    func fetchLocationsWith(region: String, completion: @escaping(([Location]?)) -> Void) {

        guard let url = baseLocationURL else { completion(nil) ; return }

//        let locationsEnd = "locations.json"
        
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
                let topLevel = try jsonDecoder.decode(TopLevelLocation.self , from: data)
                completion(topLevel.locations)
            } catch let error {

                print("Error decoding location from dataTask: \(error)")
                completion(nil)
                return
            }
            print(data)
            }.resume()
        
        
        
    }
    
} // End LocationController





































