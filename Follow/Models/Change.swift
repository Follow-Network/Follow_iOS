//
//  Change.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

struct Change: Codable {
    let daily: String
    let monthly: String
    let yearly: String
    let allTime: String
    
    enum CodingKeys: String, CodingKey {
        case daily
        case monthly
        case yearly
        case allTime = "alltime"
    }
}
