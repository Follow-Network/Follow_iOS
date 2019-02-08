//
//  Trader.swift
//  Follow
//
//  Created by Anton Grigorev on 07/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit

public class Trader: Decodable {
    
    // MARK: - Keys
    
    private enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case firstName = "first_name"
        case secondName = "second_name"
        case birthdate
        case country
        case city
        case avatarPathString = "avatar_path"
    }
    
    // MARK: - Properties
    
    let id: Int
    let nickname: String
    let firstName: String
    let secondName: String
    let birthdate: Date
    let country: String
    let city: String
    let avatarPathString: String?
    
    // MARK: - Lazy properties
    
    private(set) lazy var fullName: String = {
        return firstName + " " + secondName
    }()
    
    private(set) lazy var age: Int = {
        return Calendar.current.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
    }()
    
    private(set) lazy var avatarPath: ImagePath? = {
        guard let avatarPathString = self.avatarPathString else { return nil }
        return ImagePath.avatar(path: avatarPathString)
    }()
    
    // MARK: - Decoder initializer
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.posterPathString = try container.decodeIfPresent(String.self, forKey: .posterPathString)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)?.asDate(withFormat: .iso8601)
        self.genreIds = try container.decodeIfPresent([Int].self, forKey: .genreIds) ?? []
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.title = try container.decode(String.self, forKey: .title)
        self.backdropPathString = try container.decodeIfPresent(String.self, forKey: .backdropPathString)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.video = try container.decode(Bool.self, forKey: .video)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
    }
}

// MARK: -

extension Film: CustomStringConvertible {
    
    // MARK: - Description
    
    public var description: String {
        guard let date = releaseDate else { return originalTitle }
        return originalTitle + " " + date.asString(withFormat: .year)
    }
}

// MARK: -

extension Film: Equatable {
    
    // MARK: - Equatable
    
    public static func ==(lhs: Film, rhs: Film) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: -

extension Film: Hashable {
    
    // MARK: - Hashable
    
    public var hashValue: Int { return id }
}

// MARK: -

extension Array where Element: Film {
    
    var withoutDuplicates: [Film] {
        var exists: [Int: Bool] = [:]
        return self.filter { exists.updateValue(true, forKey: $0.id) == nil }
    }
}

