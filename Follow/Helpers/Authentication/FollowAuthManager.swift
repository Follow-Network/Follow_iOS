////
////  FollowAuthManager.swift
////  Follow
////
////  Created by Anton on 21/04/2019.
////  Copyright © 2019 Follow. All rights reserved.
////
//
//import Foundation
//import TinyNetworking
//
//protocol AuthSessionListener {
//     func didReceiveRedirect(code: String)
//}
//
//enum FollowAuthorization: ResourceType {
//
//    case accessToken(withCode: String)
//
//    var baseURL: URL {
//        guard let url = URL(string: "https://follow-network.org") else {
//            fatalError("FAILED: https://follow-network.org")
//        }
//        return url
//    }
//
//    var endpoint: Endpoint {
//        return .post(path: "/auth/token")
//    }
//
//    var task: Task {
//        switch self {
//        case let .accessToken(withCode: code):
//            var params: [String: Any] = [:]
//
//            params["grant_type"] = "authorization_code"
//            params["client_id"] = Constants.FollowSettings.clientID
//            params["client_secret"] = Constants.FollowSettings.clientSecret
//            params["redirect_uri"] = Constants.FollowSettings.redirectURL
//            params["code"] = code
//
//            return .requestWithParameters(params, encoding: URLEncoding())
//        }
//    }
//
//    var headers: [String : String] {
//        return [:]
//    }
//}
//
//class FollowAuthManager {
//
//    var delegate: AuthSessionListener!
//
//    static var shared: FollowAuthManager {
//        return FollowAuthManager(
//            clientID: Constants.FollowSettings.clientID,
//            clientSecret: Constants.FollowSettings.clientSecret,
//            scopes: Scope.allCases
//        )
//    }
//
//    // MARK: Private Properties
//    private let clientID: String
//    private let clientSecret: String
//    private let redirectURL: URL
//    private let scopes: [Scope]
//    private let service: TinyNetworking<FollowAuthorization>
//
//    // MARK: Public Properties
//    public var accessToken: String? {
//        return UserDefaults.standard.string(forKey: clientID)
//    }
//
//    public func clearAccessToken() {
//        UserDefaults.standard.removeObject(forKey: clientID)
//    }
//
//    public var authURL: URL {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host   = Constants.FollowSettings.host
//        components.path   = "/auth"
//
//        var params: [String: String] = [:]
//        params["response_type"] = "code"
//        params["client_id"]     = clientID
//        params["redirect_uri"]  = redirectURL.absoluteString
//        params["scope"]         = scopes.map { $0.rawValue }.joined(separator: "+")
//
//        let url = components.url?.appendingQueryParameters(params)
//
//        return url!
//    }
//
//    // MARK: Init
//    init(clientID:     String,
//         clientSecret: String,
//         scopes:       [Scope] = [Scope.pub],
//         service:       TinyNetworking<FollowAuthorization> = TinyNetworking<FollowAuthorization>()) {
//        self.clientID     = clientID
//        self.clientSecret = clientSecret
//        self.redirectURL  = URL(string: Constants.FollowSettings.redirectURL)!
//        self.scopes       = scopes
//        self.service       = service
//    }
//
//    // MARK: Public
//    public func receivedCodeRedirect(url: URL) {
//        guard let code = extractCode(from: url) else { return }
//        delegate.didReceiveRedirect(code: code)
//    }
//
//    public func accessToken(with code: String, completion: @escaping (String?, Error?) -> Void) {
//        service.request(resource: .accessToken(withCode: code)) { [unowned self] response in
//            switch response {
//            case let .success(result):
//                if let accessTokenObject = try? result.map(to: FollowAccessToken.self) {
//                    let token = accessTokenObject.accessToken
//                    UserDefaults.standard.set(token, forKey: self.clientID)
//                    completion(token, nil)
//                }
//            case let .error(error):
//                completion(nil, error)
//            }
//        }
//    }
//
//    // MARK: Private
//    private func accessTokenURL(with code: String) -> URL {
//        var components = URLComponents()
//        components.scheme = "https"
//        components.host   = Constants.FollowSettings.host
//        components.path   = "/token"
//
//        var params: [String: String] = [:]
//        params["grant_type"]    = "authorization_code"
//        params["client_id"]     = clientID
//        params["client_secret"] = clientSecret
//        params["redirect_uri"]  = redirectURL.absoluteString
//        params["code"]          = code
//
//        let url = components.url?.appendingQueryParameters(params)
//
//        return url!
//    }
//
//    private func extractCode(from url: URL) -> String? {
//       return url.value(for: "code")
//    }
//
//    private func extractErrorDescription(from data: Data) -> String? {
//        let error = try? JSONDecoder().decode(FollowAuthError.self, from: data)
//        return error?.errorDescription
//    }
//}
