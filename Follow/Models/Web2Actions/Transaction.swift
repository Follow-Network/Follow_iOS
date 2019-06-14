//
//  Transaction.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import RxDataSources

struct Transaction: Codable {
    let amount: String
    let timestamp: TimeInterval
    let followerId: UInt32
    let traderId: UInt32
    let txHash: String
    let signature: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case timestamp
        case followerId = "follower_id"
        case traderId = "trader_id"
        case txHash = "tx_hash"
        case signature
    }
}

extension Transaction: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
        return txHash
    }
}

extension Transaction: Equatable {
    static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.txHash == rhs.txHash
    }
}

extension Transaction: Cachable {
    var identifier: String {
        return txHash
    }
}
