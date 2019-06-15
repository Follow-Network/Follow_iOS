//
//  TransactionService.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct Web2TransactionService: Web2TransactionServiceType {
    
    private let service: TinyNetworking<Follow>
    
    init(service: TinyNetworking<Follow> = TinyNetworking<Follow>()) {
        self.service = service
    }
    
    func deposit(transaction: Transaction) -> Observable<Result<Transaction, ServiceError>> {
        return service.rx.request(resource: .deposit(amount: transaction.amount,
                                                     timestamp: transaction.timestamp,
                                                     followerId: transaction.followerId,
                                                     traderId: transaction.traderId,
                                                     txHash: transaction.txHash,
                                                     signature: transaction.signature)
            )
            .map(to: Transaction.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't accept deposit")))
            }
            .asObservable()
    }
    
    func withdraw(transaction: Transaction) -> Observable<Result<Transaction, ServiceError>> {
        return service.rx.request(resource: .withdraw(amount: transaction.amount,
                                                      timestamp: transaction.timestamp,
                                                      followerId: transaction.followerId,
                                                      traderId: transaction.traderId,
                                                      txHash: transaction.txHash,
                                                      signature: transaction.signature)
            )
            .map(to: Transaction.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't accept withdraw")))
            }
            .asObservable()
    }
    
}
