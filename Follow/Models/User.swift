//
//  User.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import RxDataSources

struct User: Codable {
    let id: UInt32
    let username: String
    let firstName: String?
    let lastName: String?
    let phone: String?
    let email: String?
    let country: String?
    let profileImage: Image?
    let posts: [Post]?
    let birthday: TimeInterval?
    let regdate: TimeInterval
    let pubkey: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case email
        case country
        case profileImage = "profile_image"
        case posts
        case birthday
        case regdate
        case pubkey
    }
}

extension User: IdentifiableType {
    typealias Identity = String
    
    var identity: Identity {
        return id.description
    }
}

extension User: Equatable {
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

extension User: Cachable {
    var identifier: String {
        return id.description
    }
}
