//
//  Result.swift
//  FollowApp
//
//  Created by Георгий Фесенко on 23/11/2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
