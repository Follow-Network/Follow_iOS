//
//  Links.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct Link: Decodable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url
    }
}

struct Links: Codable {
    let ping: String?
    let auth: String?
    let user: String?
    let set: String?
    let trader: String?
    let follower: String?
    let followers: String?
    let traders: String?
    let balance: String?
    let deals: String?
    let deposit: String?
    let withdraw: String?

    enum CodingKeys: String, CodingKey {
        case ping
        case auth
        case user
        case set
        case trader
        case followers
        case follower
        case traders
        case balance
        case deals
        case deposit
        case withdraw
    }
}
