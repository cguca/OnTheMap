//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Cary Guca on 3/31/21.
//

import Foundation

struct SessionResponse: Codable
{
    let account: Account
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
}
