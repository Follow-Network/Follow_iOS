//
//  ServiceConfiguration.swift
//  Follow
//
//  Created by Anton Grigorev on 05/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct ServiceConfiguration {
    
    // MARK: - Properties
    
    let urlScheme: String
    let urlHost: String
    let defaultHTTPHeaders: [String: String]
    let defaultURLParameters: [URLParameter]
}
