//
//  TransactionServiceType.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift

protocol TransactionServiceType {
    
    func deposit(transaction: Transaction) -> Observable<Result<Transaction, ServiceError>>
    func withdraw(transaction: Transaction) -> Observable<Result<Transaction, ServiceError>>
    
}
