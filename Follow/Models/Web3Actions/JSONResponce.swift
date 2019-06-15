//
//  JSONResponce.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import RxDataSources

struct JSONResponse: Codable {
    let id: UInt32
    let jsonrpc: String
    let result: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case jsonrpc
        case result
    }
}

extension JSONResponse: Equatable {
    static func ==(lhs: JSONResponse, rhs: JSONResponse) -> Bool {
        return lhs.result == rhs.result
    }
}

extension JSONResponse: Cachable {
    var identifier: String {
        return result
    }
}
