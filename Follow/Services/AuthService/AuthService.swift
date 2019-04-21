//
//  AuthService.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct AuthService: AuthServiceType {
    
    private let service: TinyNetworking<Follow>
    
    init(service: TinyNetworking<Follow> = TinyNetworking<Follow>()) {
        self.service = service
    }
    
    func register(pubkey: String,
                  username: String,
                  password: String,
                  signature: String) -> Observable<Result<User, ServiceError>> {
        return service.rx.request(resource: .register(pubkey: pubkey,
                                                      username: username,
                                                      password: password,
                                                      signature: signature)
            )
            .map(to: User.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't register user")))
            }
            .asObservable()
    }
    
    func authenticate(username: String, password: String) -> Observable<Result<User, ServiceError>> {
        return service.rx.request(resource: .authenticate(username: username,
                                                          password: password)
            )
            .map(to: User.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't authenticate user")))
            }
            .asObservable()
    }
    
}

