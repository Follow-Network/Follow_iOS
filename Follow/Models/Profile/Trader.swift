//
//  Trader.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct Trader: Codable {
    let followersBalance: String
    let followersCount: String
    let followersChange: [Change]
    let selfChange: [Change]
    let deals: [Deal]
    
    enum CodingKeys: String, CodingKey {
        case followersBalance = "followers_balance"
        case followersCount = "followers_count"
        case followersChange = "followers_change"
        case selfChange = "self_change"
        case deals = "deals"
    }
}

