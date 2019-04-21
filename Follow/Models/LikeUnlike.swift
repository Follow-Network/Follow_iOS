//
//  LikeUnlike.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

struct LikeUnlikePost: Decodable {
    let post: Post
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case post
        case user
    }
}

struct LikeUnlikeImage: Decodable {
    let image: Image
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case image
        case user
    }
}



