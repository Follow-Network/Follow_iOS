//
//  Order.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

enum OrderStatus: String {
    case open = "open"
    case closed = "closed"
    case expired = "expired"
    case aborted = "aborted"
}

enum OrderType: String {
    case instant = "instant"
    case deffered = "deffered"
}
