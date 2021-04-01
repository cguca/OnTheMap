//
//  StudentLocations.swift
//  OnTheMap
//
//  Created by Cary Guca on 3/31/21.
//

import Foundation

struct StudentLocationsResponse: Codable {
    let results: [Location]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
