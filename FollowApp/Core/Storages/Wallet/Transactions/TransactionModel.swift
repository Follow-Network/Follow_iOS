//
//  TransactionModel.swift
//  FollowApp
//
//  Created by Anton Grigorev on 02/12/2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation
import Web3swift

public struct ETHTransactionModel {
    let transactionHash: String
    let from: String
    let to: String
    let amount: String
    let date: Date
    let data: Data?
    let token: ERC20TokenModel? // nil if it is custom ETH transaction
    let networkID: Int64
    var isPending = false
}

public struct WriteTransactionInfo {
    var contractAddress: String
    var writeTransaction: WriteTransaction
    var methodName: String
}

public struct ReadTransactionInfo {
    var contractAddress: String
    var readTransaction: ReadTransaction
    var methodName: String
}

public enum TransactionType {
    case custom
    case arbitraryMethodWithParams
}
