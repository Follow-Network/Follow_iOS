//
//  Unsplash.swift
//  Papr
//
//  Created by Joan Disho on 31.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import TinyNetworking

enum Follow {
    
    case register(
        pubkey: String,
        username: String,
        password: String,
        signature: String)
    
    case authenticate(
        username: String,
        password: String)

    case setMe(
        id: UInt32,
        username: String?,
        firstName: String?,
        lastName: String?,
        phone: String?,
        email: String?,
        country: String?,
        imageUrl: String?,
        birthday: TimeInterval?,
        regdate: TimeInterval?,
        signature: String)
    
    case getMe(id: UInt32)

    case getUser(id: UInt32)
    
    case getTrader(id: UInt32)
    
    case getTraderFollowers(id: UInt32)
    
    case getTraderBalance(
        id: UInt32,
        startTime: TimeInterval?,
        endTime: TimeInterval?,
        period: UInt?)
    
    case getDeals(
        id: UInt32,
        page: UInt32?)
    
    case getFollower(id: UInt32)
    
    case getFollowerTraders(id: UInt32)
    
    case getFollowerBalance(
        id: UInt32,
        startTime: String?,
        endTime: String?,
        period: String?)
    
    case getTraders(
        sort: Int?,
        page: UInt64?
    )
    
    case deposit(
        amount: String,
        timestamp: TimeInterval,
        followerId: UInt32,
        traderId: UInt32,
        txHash: String,
        signature: String
    )
    
    case withdraw(
        amount: String,
        timestamp: TimeInterval,
        followerId: UInt32,
        traderId: UInt32,
        signature: String
    )
}

extension Follow: ResourceType {

    var baseURL: URL {
        guard let url = URL(string: "https://api.thefollow.org") else {
            fatalError("FAILED: https://api.thefollow.org")
        }
        return url
    }
    
    var endpoint: Endpoint {
        switch self {
        case .register:
            return .post(path: "/join")
        case .authenticate:
            return .post(path: "/auth")
        case let .setMe(param):
            return .post(path: "/user/\(param.id)/set")
        case let .getMe(id):
            return .get(path: "/user\(id)")
        case let .getUser(id):
            return .get(path: "/user\(id)")
        case let .getTrader(id):
            return .get(path: "/user\(id)/trader")
        case let .getTraderFollowers(id):
            return .get(path: "/user\(id)/trader/followers")
        case let .getTraderBalance(param):
            return .get(path: "/user\(param.id)/trader/balance/start=\(param.startTime)&end=\(param.endTime)&period=\(param.period)")
        case let .getDeals(param):
            return .get(path: "/user/\(param.id)/trader/deals/\(param.page)")
        case let .getFollower(id):
            return .get(path: "/user\(id)/follower")
        case let .getFollowerTraders(id):
            return .get(path: "/user\(id)/follower/traders")
        case let .getFollowerBalance(param):
            return .get(path: "/user\(param.id)/follower/balance/start=\(param.startTime)&end=\(param.endTime)&period=\(param.period)")
        case let .getTraders(param):
            return .get(path: "/traders/\(param.sort)/\(param.page)")
        case .deposit:
            return .post(path: "/deposit")
        case .withdraw:
            return .post(path: "/withdraw")
        }
    }

    var task: Task {
        let noBracketsAndLiteralBoolEncoding = URLEncoding(
            arrayEncoding: .noBrackets,
            boolEncoding: .literal
        )

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

        case let .setMe(value):

            var params: [String: Any] = [:]
            params["username"] = value.username
            params["first_name"] = value.firstName
            params["last_name"] = value.lastName
            params["phone"] = value.phone
            params["email"] = value.email
            params["country"] = value.country
            params["image_url"] = value.imageUrl
            params["birthday"] = value.birthday
            params["regdate"] = value.regdate
            params["signature"] = value.signature

            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getMe(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getUser(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getTrader(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getTraderFollowers(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getTraderBalance(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getDeals(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getFollower(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getFollowerTraders(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getFollowerBalance(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getTraders(value):
            
            var params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .deposit(value):
            
            var params: [String: Any] = [:]
            params["amount"] = value.amount
            params["timestamp"] = value.timestamp
            params["follower_id"] = value.followerId
            params["trader_id"] = value.traderId
            params["tx_hash"] = value.txHash
            params["signature"] = value.signature
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .withdraw(value):
            
            var params: [String: Any] = [:]
            params["amount"] = value.amount
            params["timestamp"] = value.timestamp
            params["follower_id"] = value.followerId
            params["trader_id"] = value.traderId
            params["signature"] = value.signature
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        default:
            return .requestWithParameters([:], encoding: URLEncoding())
        }
    }

    var headers: [String : String] {
        let clientID = Constants.FollowSettings.clientID
        guard let token = UserDefaults.standard.string(forKey: clientID) else {
            return ["Authorization": "Client-ID \(clientID)"]
        }
        return ["Authorization": "Bearer \(token)"]
    }
}
