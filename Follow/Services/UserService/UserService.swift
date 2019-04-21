//
//  UserService.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import TinyNetworking
import RxSwift

struct UserService: UserServiceType {

    private let service: TinyNetworking<Follow>
    private let cache: Cache

    init(service: TinyNetworking<Follow> = TinyNetworking<Follow>(),
         cache: Cache = Cache.shared) {
        self.service = service
        self.cache = cache
    }

    func getMe(id: UInt32) -> Observable<Result<User, ServiceError>> {
        return service.rx
            .request(resource: .getMe(id: id))
            .map(to: User.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get self profile")))
            }
            .asObservable()
    }
    
    func setMe(user: User,
               imageData: Data?,
               signature: String) -> Observable<Result<User, ServiceError>> {
        return service.rx
            .request(resource: .setMe(id: user.id,
                                      username: user.username,
                                      firstName: user.firstName,
                                      lastName: user.lastName,
                                      phone: user.phone,
                                      email: user.email,
                                      country: user.country,
                                      image: imageData,
                                      birthday: user.birthday,
                                      regdate: user.regdate,
                                      pubkey: user.pubkey,
                                      signature: signature))
            .map(to: User.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't set self profile")))
            }
            .asObservable()
    }
    
    func getUser(id: UInt32) -> Observable<Result<User, ServiceError>> {
        return service.rx
            .request(resource: .getUser(id: id))
            .map(to: User.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get self profile")))
            }
            .asObservable()
    }
    
    func getTraderData(id: UInt32) -> Observable<Result<Trader, ServiceError>> {
        return service.rx
            .request(resource: .getTrader(id: id))
            .map(to: Trader.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users trader profile")))
            }
            .asObservable()
    }
    
    func getTraderFollowers(id: UInt32) -> Observable<Result<[User], ServiceError>> {
        return service.rx
            .request(resource: .getTraderFollowers(id: id))
            .map(to: [User].self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users trader followers")))
            }
            .asObservable()
    }
    
    func getTraderBalance(id: UInt32,
                          startTime: TimeInterval?,
                          endTime: TimeInterval?,
                          period: UInt?) -> Observable<Result<String, ServiceError>> {
        return service.rx
            .request(resource: .getTraderBalance(id: id,
                                                 startTime: startTime,
                                                 endTime: endTime,
                                                 period: period))
            .map(to: String.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users trader balance")))
            }
            .asObservable()
    }
    
    func getTraderDeals(id: UInt32,
                        page: UInt32?) -> Observable<Result<[Deal], ServiceError>> {
        return service.rx
            .request(resource: .getDeals(id: id,
                                         page: page))
            .map(to: [Deal].self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users trader deals")))
            }
            .asObservable()
    }
    
    func getFollowerData(id: UInt32) -> Observable<Result<Follower, ServiceError>> {
        return service.rx
            .request(resource: .getFollower(id: id))
            .map(to: Follower.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users follower profile")))
            }
            .asObservable()
    }
    
    func getFollowerTraders(id: UInt32) -> Observable<Result<[User], ServiceError>> {
        return service.rx
            .request(resource: .getFollowerTraders(id: id))
            .map(to: [User].self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users follower traders")))
            }
            .asObservable()
    }
    
    func getFollowerBalance(id: UInt32,
                            startTime: TimeInterval?,
                            endTime: TimeInterval?,
                            period: UInt?) -> Observable<Result<String, ServiceError>> {
        return service.rx
            .request(resource: .getFollowerBalance(id: id,
                                                   startTime: startTime,
                                                   endTime: endTime,
                                                   period: period))
            .map(to: String.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users follower balance")))
            }
            .asObservable()
    }
    
    func getPosts(id: UInt32,
                  page: UInt32?,
                  orderBy: PostsOrderBy?) -> Observable<Result<[Post], ServiceError>> {
        return service.rx
            .request(resource: .getPosts(id: id,
                                         page: page,
                                         orderBy: orderBy))
            .map(to: [Post].self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get users posts")))
            }
            .asObservable()
    }
}
