//
//  Follower.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct Follower: Codable {
    let deposit: String
    let balance: String
    let tradersCount: String
    let tradersChange: [Change]
    let selfChange: [Change]
    
    enum CodingKeys: String, CodingKey {
        case deposit
        case balance
        case tradersCount = "traders_count"
        case tradersChange = "traders_change"
        case selfChange = "self_change"
    }
}
