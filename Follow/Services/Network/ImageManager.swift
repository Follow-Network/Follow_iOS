//
//  ImageManager.swift
//  Follow
//
//  Created by Anton Grigorev on 07/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit

public enum ImageSize {
    
    // MARK: - Cases
    
    case small
    case medium
    case big
    case original
    
    static var avatarRatio: CGFloat = (2.0 / 3.0)
}

// MARK: -

public enum ImagePath {
    
    // MARK: - Cases
    
    case avatar(path: String)
    
    // MARK: - Properties
    
    var path: String {
        switch self {
        case .avatar(let path): return path
        }
    }
}

// MARK: -

public final class ImageManager: NSObject {
    
    // MARK: - Properties
    
    fileprivate let apiConfiguration: APIConfiguration
    
    // MARK: - Initializer
    
    public init(apiConfiguration: APIConfiguration) {
        self.apiConfiguration = apiConfiguration
    }
    
    // MARK: - Helper functions
    
    private func pathComponent(forSize size: ImageSize, andPath imagePath: ImagePath) -> String {
        let array: [String] = {
            switch imagePath {
            case .backdrop: return self.apiConfiguration.backdropSizes
            case .logo: return self.apiConfiguration.logoSizes
            case .poster: return self.apiConfiguration.posterSizes
            case .profile: return self.apiConfiguration.profileSizes
            case .still: return self.apiConfiguration.stillSizes
            }
        }()
        let sizeComponentIndex: Int = {
            switch size {
            case .small: return 0
            case .medium: return array.count / 2
            case .big: return array.count - 2
            case .original: return array.count - 1
            }
        }()
        let sizeComponent: String = array[sizeComponentIndex]
        return "\(sizeComponent)/\(imagePath.path)"
    }
    
    func url(fromTMDbPath imagePath: ImagePath, withSize size: ImageSize) -> URL? {
        let pathComponent = self.pathComponent(forSize: size, andPath: imagePath)
        let url = URL(string: self.apiConfiguration.imagesSecureBaseURLString)?.appendingPathComponent(pathComponent)
        return url
    }
}
