//
//  AuthServiceType.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthServiceType {
    static func register(pubkey: String,
                         username: String,
                         password: String,
                         signature: String,
                         completion: @escaping (UserCreds?, ServiceError?) -> Void)
    static func authenticate(username: String,
                             password: String,
                             completion: @escaping (UserCreds?, ServiceError?) -> Void)
    func accessToken(with creds: UserCreds,
                     completion: @escaping (AccessToken?, ServiceError?) -> Void)
}
