//
//  Post.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import RxDataSources

struct Post: Codable {
    let id: UInt64
    let createdAt: TimeInterval
    let updatedAt: TimeInterval
    let description: String
    var likes: UInt32
    var likedByUser: Bool?
    let views: UInt32
    let user: User
    let images: [Image?]
    let links: Links?
    let deal: Deal?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description
        case likes
        case likedByUser = "liked_by_user"
        case views
        case user
        case images = "images"
        case links
        case deal
    }
}

extension Post: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
        return id.description
    }
}

extension Post: Equatable {
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id &&
            lhs.user.id == rhs.user.id
    }
}

extension Post: Cachable {
    var identifier: String {
        return id.description
    }
}
