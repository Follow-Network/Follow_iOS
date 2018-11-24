//
//  NetworkErrors.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation

enum NetworkErrors: Error {
    case couldnotParseJSON
    case problemsWithInsertingNewEntity
}
