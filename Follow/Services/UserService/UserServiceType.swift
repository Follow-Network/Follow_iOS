//
//  UserServiceType.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift

protocol UserServiceType {
    func getMe(id: UInt32) -> Observable<Result<User, ServiceError>>
    func setMe(user: User,
               imageData: Data?,
               signature: String) -> Observable<Result<User, ServiceError>>
    func getUser(id: UInt32) -> Observable<Result<User, ServiceError>>
    func getTraderData(id: UInt32) -> Observable<Result<Trader, ServiceError>>
    func getTraderFollowers(id: UInt32) -> Observable<Result<[User], ServiceError>>
    func getTraderBalance(id: UInt32,
                          startTime: TimeInterval?,
                          endTime: TimeInterval?,
                          period: UInt?) -> Observable<Result<String, ServiceError>>
    func getTraderDeals(id: UInt32,
                        page: UInt32?) -> Observable<Result<[Deal], ServiceError>>
    func getFollowerData(id: UInt32) -> Observable<Result<Follower, ServiceError>>
    func getFollowerTraders(id: UInt32) -> Observable<Result<[User], ServiceError>>
    func getFollowerBalance(id: UInt32,
                            startTime: TimeInterval?,
                            endTime: TimeInterval?,
                            period: UInt?) -> Observable<Result<String, ServiceError>>
}
