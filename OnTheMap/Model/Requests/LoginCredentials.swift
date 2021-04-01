//
//  LoginCredentials.swift
//  OnTheMap
//
//  Created by Cary Guca on 3/31/21.
//

import Foundation

struct LoginCredentials: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
