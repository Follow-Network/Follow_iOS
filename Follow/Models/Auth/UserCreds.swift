//
//  UserCreds.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct UserCreds: Decodable {
    let clientID: String
    let clientSecret: String
    
    enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case clientSecret = "client_ecret"
    }
}
