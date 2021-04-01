//
//  UpdateStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Cary Guca on 3/31/21.
//

import Foundation

struct UpdateStudentLocationResponse: Codable {
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case updatedAt
    }
}
