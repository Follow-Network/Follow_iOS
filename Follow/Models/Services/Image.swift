//
//  Image.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import RxDataSources

struct Image: Codable {
    let id: UInt64
    let description: String
    var likes: UInt32
    var likedByUser: Bool?
    let width: UInt32
    let height: UInt32
    let ownerId: UInt32
    let urls: ImageURLs
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case likes
        case likedByUser = "liked_by_user"
        case width
        case height
        case ownerId = "owner_id"
        case urls
    }
}

extension Image: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
        return id.description
    }
}

extension Image: Equatable {
    static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.id == rhs.id &&
            lhs.ownerId == rhs.ownerId
    }
}

extension Image: Cachable {
    var identifier: String {
        return id.description
    }
}

