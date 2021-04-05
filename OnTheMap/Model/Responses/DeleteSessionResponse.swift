//
//  DeleteSessionResponse.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/4/21.
//

import Foundation

struct DeleteSessionResponse: Codable
{
    let session: Session
    
    enum CodingKeys: String, CodingKey {
        case session
    }
}
