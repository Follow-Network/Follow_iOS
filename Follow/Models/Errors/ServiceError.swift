//
//  ServiceError.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

enum ServiceError {
    case noAccessToken
    case error(withMessage: String)
}
