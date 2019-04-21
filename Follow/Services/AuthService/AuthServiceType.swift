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
    func register(pubkey: String,
                  username: String,
                  password: String,
                  signature: String) -> Observable<Result<User, ServiceError>>
    func authenticate(username: String, password: String) -> Observable<Result<User, ServiceError>>
}
