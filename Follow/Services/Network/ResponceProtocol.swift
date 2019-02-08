//
//  ResponceProtocol.swift
//  Follow
//
//  Created by Anton Grigorev on 05/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

protocol ResponseProtocol: CustomStringConvertible, CustomDebugStringConvertible {
    
    // MARK: - Properties
    
    var request: RequestProtocol { get }
    var data: Result<Data> { get }
    
    // MARK: - Initializer
    
    init(request: RequestProtocol, data: Result<Data>)
}

// MARK: -

extension ResponseProtocol {
    
    // MARK: - CustomStringConvertible
    
    var description: String {
        switch self.data {
        case .success: return "[RESPONSE PROTOCOL] ✅ SUCCESSFUL \(request.path)"
        case .failure(let error): return "[RESPONSE PROTOCOL] ❌ FAILURE \(request.path)\n\(error)"
        }
    }
    
    var debugDescription: String { return description }
}
