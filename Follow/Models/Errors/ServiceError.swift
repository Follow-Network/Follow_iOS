//
//  ServiceError.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

enum ServiceError: Error {
    case wrongSignedTx
    case noAccessToken
    case error(withMessage: String)
}
