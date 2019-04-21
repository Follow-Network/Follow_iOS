//
//  Constants.swift
//  Follow
//
//  Created by Anton on 19/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let tradersPerPage = 10
    
    struct Appearance {
        struct Color {
            static let iron = UIColor(red: 94.0/255.0, green: 94.0/255.0, blue: 94.0/255.0, alpha: 1.0)
            static let yellowZ = UIColor(red: 252.0/255.0, green: 197.0/255.0, blue: 6.0/255.0, alpha: 1.0)
        }
        
        struct Style {
            static let imageCornersRadius: CGFloat = 8.0
        }
    }
    
    struct FollowSettings {
        static let host = "follow-network.org"
        static let callbackURLScheme = "follow://"
        static let clientID = FollowSecrets.clientID
        static let clientSecret = FollowSecrets.clientSecret
        static let authorizeURL = "https://follow-network.org/authorize"
        static let tokenURL = "https://follow-network.org/token"
        static let redirectURL = "follow://follow-network.org"
        
        struct FollowSecrets {
            
            static let clientID = FollowSecrets.environmentVariable(named: "FOLLOW_CLIENT_ID") ?? ""
            static let clientSecret = FollowSecrets.environmentVariable(named: "FOLLOW_CLIENT_SECRET") ?? ""
            
            private static func environmentVariable(named: String) -> String? {
                guard let infoDictionary = Bundle.main.infoDictionary, let value = infoDictionary[named] as? String else {
                    print("‼️ Missing Environment Variable: '\(named)'")
                    return nil
                }
                return value
            }
        }
    }
}

