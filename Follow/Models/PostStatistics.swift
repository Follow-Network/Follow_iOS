//
//  PostStatistics.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct Stats: Decodable {
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case total
    }
}

struct PostStatistics: Decodable {
    let id: String
    let views: Stats
    let likes: Stats

    enum CodingKeys: String, CodingKey {
        case id
        case views
        case likes
    }
}
