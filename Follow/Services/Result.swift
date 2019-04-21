//
//  Result.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

public enum Result<T, E> {
    case success(T)
    case error(E)
}
