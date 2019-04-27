//
//  Follow.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import TinyNetworking

enum Follow {
    
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

    case setMe(
        id: UInt32,
        username: String?,
        firstName: String?,
        lastName: String?,
        phone: String?,
        email: String?,
        country: String?,
        image: Data?,
        birthday: TimeInterval?,
        regdate: TimeInterval?,
        pubkey: String,
        signature: String
    )
    
    case getMe(id: UInt32)

    case getUser(id: UInt32)
    
    case getTrader(id: UInt32)
    
    case getTraderFollowers(id: UInt32)
    
    case getTraderBalance(
        id: UInt32,
        startTime: TimeInterval?,
        endTime: TimeInterval?,
        period: UInt?
    )
    
    case getPosts(
        id: UInt32,
        page: UInt32?,
        orderBy: PostsOrderBy?
    )
    
    case getDeals(
        id: UInt32,
        page: UInt32?
    )
    
    case getFollower(id: UInt32)
    
    case getFollowerTraders(id: UInt32)
    
    case getFollowerBalance(
        id: UInt32,
        startTime: TimeInterval?,
        endTime: TimeInterval?,
        period: UInt?
    )
    
    case getTraders(
        page: UInt64?,
        orderBy: TradersOrderBy?
    )
    
    case searchTraders(
        query: String,
        page: UInt64?,
        orderBy: TradersOrderBy?
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
        txHash: String,
        signature: String
    )
    
    case likeImage(id: UInt64)
    
    case unlikeImage(id: UInt64)
    
    case likePost(
        userId: UInt32,
        postId: UInt64
    )
    
    case unlikePost(
        userId: UInt32,
        postId: UInt64
    )
    
    case makePost(
        createdAt: TimeInterval,
        updatedAt: TimeInterval,
        description: String,
        likes: UInt32,
        views: UInt32,
        userId: UInt32,
        images: [String?],
        dealId: UInt64?
    )
}

extension Follow: ResourceType {

    var baseURL: URL {
        guard let url = URL(string: "https://api.follow-network.org") else {
            fatalError("FAILED: https://api.follow-network.org")
        }
        return url
    }
    
    var endpoint: Endpoint {
        switch self {
        case .register:
            return .post(path: "/join")
        case .authenticate:
            return .post(path: "/auth")
        case .setMe:
            return .post(path: "/user/set")
        case let .getMe(id):
            return .get(path: "/user/\(id)")
        case let .getUser(id):
            return .get(path: "/user/\(id)")
        case let .getTrader(id):
            return .get(path: "/user/\(id)/trader")
        case let .getTraderFollowers(id):
            return .get(path: "/user/\(id)/trader/followers")
        case let .getTraderBalance(param):
            let startTime = param.startTime != nil ? param.startTime!.description : "0"
            let endTime = param.endTime != nil ? param.endTime!.description : "0"
            let period = param.period != nil ? param.period!.description : "4"
            return .get(path: "/user/\(param.id)/trader/balance/start=\(startTime)&end=\(endTime)&period=\(period)")
        case let .getDeals(param):
            let page = param.page != nil ? param.page!.description : ""
            return .get(path: "/user/\(param.id)/trader/deals/\(page)")
        case let .getFollower(id):
            return .get(path: "/user/\(id)/follower")
        case let .getFollowerTraders(id):
            return .get(path: "/user/\(id)/follower/traders")
        case let .getFollowerBalance(param):
            let startTime = param.startTime != nil ? param.startTime!.description : "0"
            let endTime = param.endTime != nil ? param.endTime!.description : "0"
            let period = param.period != nil ? param.period!.description : "4"
            return .get(path: "/user/\(param.id)/follower/balance/start=\(startTime)&end=\(endTime)&period=\(period)")
        case let .getTraders(param):
            let page = param.page != nil ? param.page!.description : ""
            return .get(path: "/traders/\(page)")
        case let .searchTraders(param):
            let page = param.page != nil ? param.page!.description : ""
            return .get(path: "/traders/\(param.query)/\(page)")
        case .deposit:
            return .post(path: "/deposit")
        case .withdraw:
            return .post(path: "/withdraw")
        case let .likeImage(id):
            return .post(path: "/images/\(id)/like")
        case let .unlikeImage(id):
            return .delete(path: "/images/\(id)/like")
        case let .likePost(param):
            return .post(path: "/user/\(param.userId)/posts/\(param.postId)/like")
        case let .unlikePost(param):
            return .delete(path: "/user/\(param.userId)/posts/\(param.postId)/like")
        case let .getPosts(param):
            let page = param.page != nil ? param.page!.description : ""
            return .get(path: "/user/\(param.id)/posts/\(page)")
        case let .makePost(param):
            return .post(path: "/user/\(param.userId)/makePost")
        }
    }

    var task: Task {
//        let noBracketsAndLiteralBoolEncoding = URLEncoding(
//            arrayEncoding: .noBrackets,
//            boolEncoding: .literal
//        )

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
            params["id"] = value.id
            params["username"] = value.username
            params["first_name"] = value.firstName
            params["last_name"] = value.lastName
            params["phone"] = value.phone
            params["email"] = value.email
            params["country"] = value.country
            params["image"] = value.image
            params["birthday"] = value.birthday
            params["regdate"] = value.regdate
            params["pubkey"] = value.pubkey
            params["signature"] = value.signature

            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getMe:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getUser:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getTrader:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getTraderFollowers:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getTraderBalance:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getDeals:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getFollower:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getFollowerTraders:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .getFollowerBalance:
            
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getTraders(value):
            
            var params: [String: Any] = [:]
            params["order_by"] = value.orderBy
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .searchTraders(value):
            
            var params: [String: Any] = [:]
            params["order_by"] = value.orderBy
            
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
            params["tx_hash"] = value.txHash
            params["signature"] = value.signature
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .likeImage:
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .unlikeImage:
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .likePost:
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case .unlikePost:
            let params: [String: Any] = [:]
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .getPosts(value):
            var params: [String: Any] = [:]
            params["order_by"] = value.orderBy
            
            return .requestWithParameters(params, encoding: URLEncoding())
            
        case let .makePost(value):
            
            var params: [String: Any] = [:]
            params["id"] = 0
            params["createdAt"] = value.createdAt
            params["updatedAt"] = value.updatedAt
            params["description"] = value.description
            params["likes"] = value.likes
            params["views"] = value.views
            params["user_id"] = value.userId
            params["images"] = value.images
            params["deal_id"] = value.dealId
            
            return .requestWithParameters(params, encoding: URLEncoding())
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
