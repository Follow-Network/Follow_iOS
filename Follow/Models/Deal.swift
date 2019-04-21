//
//  Deal.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import RxDataSources

struct Deal: Codable {
    let id: UInt64
    let orderType: String
    let orderStatus: String
    let firstCurrency: String
    let secondCurrency: String
    let value: String
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderType = "order_type"
        case orderStatus = "order_status"
        case firstCurrency = "first_currency"
        case secondCurrency = "second_currency"
        case value
        case user
    }
}

extension Deal: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
        return id.description
    }
}

extension Deal: Equatable {
    static func ==(lhs: Deal, rhs: Deal) -> Bool {
        return lhs.id == rhs.id &&
            lhs.user.id == rhs.user.id
    }
}

extension Deal: Cachable {
    var identifier: String {
        return id.description
    }
}
