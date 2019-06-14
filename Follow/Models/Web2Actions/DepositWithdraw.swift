//
//  DepositWithdraw.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct DepositWithdraw: Decodable {
    let trader: User
    let user: User

    enum CodingKeys: String, CodingKey {
        case trader
        case user
    }
}
