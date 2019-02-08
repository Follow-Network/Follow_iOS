//
//  RequestProtocol.swift
//  Follow
//
//  Created by Anton Grigorev on 05/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    
    // MARK: - Properties
    
    var path: String { get }
    var method: RequestMethod { get }
    var body: RequestBody? { get }
    var headers: [String: String] { get }
    var parameters: [URLParameter] { get }
}

// MARK: -

extension RequestProtocol {
    
    // MARK: - Default properties
    
    
}

enum RequestMethod: String {
    
    // MARK: - Cases
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public enum RequestBody {
    
    // MARK: - Cases
    
    case json(parameters: [String: Any])
    case base64(data: Data)
    
    // MARK: - Properties
    
    var data: Data? {
        switch self {
        case .json(let parameters):
            do {
                return try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                return nil
            }
        case .base64(let data):
            return data.base64EncodedString().data(using: .utf8)
        }
    }
    
    var contentType: String {
        switch self {
        case .json: return "application/json"
        case .base64: return "text/plain"
        }
    }
}
