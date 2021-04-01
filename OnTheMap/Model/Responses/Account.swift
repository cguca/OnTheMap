//
//  Account.swift
//  OnTheMap
//
//  Created by Cary Guca on 3/31/21.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key: Int
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
}
