//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Cary Guca on 3/31/21.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: [String:String]
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}
