//
//  SearchService.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct SearchService: SearchServiceType {
    
    private let service: TinyNetworking<Follow>
    private let cache: Cache

    init(service: TinyNetworking<Follow> = TinyNetworking<Follow>(),
         cache: Cache = Cache.shared) {
        self.service = service
        self.cache = cache
    }
    
    func searchTraders(with query: String, page: UInt64?, orderBy: TradersOrderBy?) -> Observable<Result<[User], ServiceError>> {
        if page == 1 { cache.clear() }
        return service.rx.request(resource: .searchTraders(query: query,
                                                           page: page,
                                                           orderBy: orderBy)
            )
            .map(to: [User].self)
            .asObservable()
            .flatMapIgnore { Observable.just(self.cache.set(values: $0)) }
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get traders")))
        }
    }
    
    func getTraders(page: UInt64?, orderBy: TradersOrderBy?) -> Observable<Result<[User], ServiceError>> {
        if page == 1 { cache.clear() }
        return service.rx.request(resource: .getTraders(page: page,
                                                        orderBy: orderBy)
            )
            .map(to: [User].self)
            .asObservable()
            .flatMapIgnore { Observable.just(self.cache.set(values: $0)) }
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get traders")))
            }
    }

}
