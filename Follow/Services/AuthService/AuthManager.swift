
//  AuthManager.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

protocol AuthSessionListener {
     func didReceiveRedirect(code: String)
}

fileprivate enum FollowAuthorization: ResourceType {

    case accessToken(withCode: String)

    var baseURL: URL {
        guard let url = URL(string: "https://follow-network.org") else {
            fatalError("FAILED: https://follow-network.org")
        }
        return url
    }

    var endpoint: Endpoint {
        return .post(path: "/auth/token")
    }

    var task: Task {
        switch self {
        case let .accessToken(withCode: code):
            var params: [String: Any] = [:]

            params["grant_type"] = "authorization_code"
            params["client_id"] = Constants.FollowSettings.clientID
            params["client_secret"] = Constants.FollowSettings.clientSecret
            params["redirect_uri"] = Constants.FollowSettings.redirectURL
            params["code"] = code

            return .requestWithParameters(params, encoding: URLEncoding())
        }
    }

    var headers: [String : String] {
        return [:]
    }
}

class AuthManager: AuthServiceType {

    var delegate: AuthSessionListener!

    static var shared: AuthManager {
        return AuthManager(
            clientID: Constants.FollowSettings.clientID,
            clientSecret: Constants.FollowSettings.clientSecret,
            scopes: Scope.allCases
        )
    }

    // MARK: Private Properties
    private let clientID: String
    private let clientSecret: String
    private let redirectURL: URL
    private let scopes: [Scope]
    private let service: TinyNetworking<Follow>

    // MARK: Public Properties
    public var accessToken: String? {
        return UserDefaults.standard.string(forKey: clientID)
    }

    public func clearAccessToken() {
        UserDefaults.standard.removeObject(forKey: clientID)
    }

    // MARK: Init
    init(clientID:     String,
         clientSecret: String,
         scopes:       [Scope] = [Scope.pub],
         service:      TinyNetworking<Follow> = TinyNetworking<Follow>()) {
        self.clientID     = clientID
        self.clientSecret = clientSecret
        self.redirectURL  = URL(string: Constants.FollowSettings.redirectURL)!
        self.scopes       = scopes
        self.service      = service
    }

    // MARK: Public
    public func receivedCodeRedirect(url: URL) {
        guard let code = extractCode(from: url) else { return }
        delegate.didReceiveRedirect(code: code)
    }
    
    public func register(pubkey: String,
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
    
    public func authenticate(username: String, password: String) -> Observable<Result<User, ServiceError>> {
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

    public func accessToken(with code: String, completion: @escaping (AccessToken?, ServiceError?) -> Void) {
        service.request(resource: .accessToken(withCode: code)) { [unowned self] response in
            switch response {
            case let .success(result):
                if let accessTokenObject = try? result.map(to: AccessToken.self) {
                    let token = accessTokenObject.accessToken
                    UserDefaults.standard.set(token, forKey: self.clientID)
                    completion(accessTokenObject, nil)
                }
            case let .error(error):
                completion(nil, .error(withMessage: "Access token error: \(error)"))
            }
        }
    }

    private func extractCode(from url: URL) -> String? {
       return url.value(for: "code")
    }
}
