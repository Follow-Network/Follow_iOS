
//  AuthManager.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

fileprivate enum Auth: ResourceType {
    case register(
        pubkey: String,
        username: String,
        password: String,
        signature: String
    )
    
    case authenticate(
        username: String,
        password: String
    )
    
    case accessToken(
        withCreds: UserCreds
    )
    
    var baseURL: URL {
        let urlString = Constants.FollowSettings.https +
            Constants.FollowSettings.apiPrefix +
            Constants.FollowSettings.host
        guard let url = URL(string: urlString) else {
            fatalError("FAILED: \(urlString)")
        }
        return url
    }
    
    var endpoint: Endpoint {
        switch self {
        case .register:
            return .post(path: "/join")
        case .authenticate:
            return .post(path: "/auth/authorize")
        case .accessToken:
            return .post(path: "/auth/token")
        }
    }
    
    var task: Task {
        switch self {
        case let .register(value):
            
            var params: [String: Any] = [:]
            params["pubkey"] = value.pubkey
            params["username"] = value.username
            params["password"] = value.password
            params["signature"] = value.signature
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .authenticate(value):
            
            var params: [String: Any] = [:]
            params["username"] = value.username
            params["password"] = value.password
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .accessToken(value):
            
            var params: [String: Any] = [:]
            params["grant_type"] = "authorization_code"
            params["client_id"] = value.clientID
            params["client_secret"] = value.clientSecret
            
            return .requestWithParameters(params, encoding: URLEncoding())
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}

class AuthManager: AuthServiceType {

    static var shared: AuthManager {
        return AuthManager(
            clientID: Constants.FollowSettings.clientID,
            clientSecret: Constants.FollowSettings.clientSecret,
            scopes: Scope.allCases
        )
    }

    // MARK: Private Properties
    private let clientID: String?
    private let clientSecret: String?
    private let scopes: [Scope]
    private static let service: TinyNetworking<Auth> = TinyNetworking<Auth>()

    // MARK: Public Properties
    public var accessToken: String? {
        return clientID != nil ? UserDefaults.standard.string(forKey: clientID!) : nil
    }

    public func clearAccessToken() {
        if clientID != nil { UserDefaults.standard.removeObject(forKey: clientID!) }
    }

    // MARK: Init
    init(clientID:     String? = nil,
         clientSecret: String? = nil,
         scopes:       [Scope] = [Scope.pub]) {
        self.clientID     = clientID
        self.clientSecret = clientSecret
        self.scopes       = scopes
    }

    // MARK: Public
    
    public static func register(pubkey: String,
                                username: String,
                                password: String,
                                signature: String,
                                completion: @escaping (UserCreds?, ServiceError?) -> Void) {
        service.request(resource: .register(pubkey: pubkey,
                                            username: username,
                                            password: password,
                                            signature: signature)) { response in
            switch response {
            case let .success(result):
                if let userCredsObject = try? result.map(to: UserCreds.self) {
                    let clientId = userCredsObject.clientID
                    let clientSecret = userCredsObject.clientSecret
                    UserDefaults.standard.set(clientId, forKey: "clientId")
                    UserDefaults.standard.set(clientSecret, forKey: "clientSecret")
                    completion(userCredsObject, nil)
                }
            case let .error(error):
                completion(nil, .error(withMessage: "Register error: \(error)"))
            }
        }
    }
    
    public static func authenticate(username: String,
                                    password: String,
                                    completion: @escaping (UserCreds?, ServiceError?) -> Void) {
        service.request(resource: .authenticate(username: username,
                                                password: password)) { response in
            switch response {
            case let .success(result):
                if let userCredsObject = try? result.map(to: UserCreds.self) {
                    let clientId = userCredsObject.clientID
                    let clientSecret = userCredsObject.clientSecret
                    UserDefaults.standard.set(clientId, forKey: "clientId")
                    UserDefaults.standard.set(clientSecret, forKey: "clientSecret")
                    completion(userCredsObject, nil)
                }
            case let .error(error):
                completion(nil, .error(withMessage: "Auth error: \(error)"))
            }
        }
    }

    public func accessToken(with creds: UserCreds,
                            completion: @escaping (AccessToken?, ServiceError?) -> Void) {
        if let clientID = clientID {
            AuthManager.service.request(resource: .accessToken(withCreds: creds)) { response in
                switch response {
                case let .success(result):
                    if let accessTokenObject = try? result.map(to: AccessToken.self) {
                        let token = accessTokenObject.accessToken
                        UserDefaults.standard.set(token, forKey: clientID)
                        completion(accessTokenObject, nil)
                    }
                case let .error(error):
                    completion(nil, .error(withMessage: "Access token error: \(error)"))
                }
            }
        } else {
            completion(nil, .error(withMessage: "Cant find client ID"))
        }
    }
}
