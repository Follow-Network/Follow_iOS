//
//  ImageURLs.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

struct ImageURLs: Codable {
    let full: String?
    let raw: String?
    let regular: String?
    let small: String?
    let thumb: String?

    enum CodingKeys: String, CodingKey {
        case full
        case raw
        case regular
        case small
        case thumb
    }
}

