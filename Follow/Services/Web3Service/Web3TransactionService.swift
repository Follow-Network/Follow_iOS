//
//  Web3TransactionService.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import web3swift
import BigInt

class Web3TransactionService {
    public static func prepareSendEthTransaction(password: String,
                                                 wallet: Wallet,
                                                 toAddress: EthereumAddress,
                                                 value: Float = 0.0) throws -> EthereumTransaction {
        do {
            var options = TransactionOptions.defaultOptions
            options.value = BigUInt(value)
            var tx = EthereumTransaction(to: toAddress, data: Data(), options: options)
            guard let keystore = try WalletService.getKeystoreManager(wallet: wallet).walletForAddress(wallet.address) else {
                throw WalletError.storageError
            }
            try Web3Signer.signTX(transaction: &tx, keystore: keystore, account: wallet.address, password: password)
            return tx
        } catch let error {
            throw error
        }
    }
    
    public static func getTransactionHash(_ tx: EthereumTransaction) throws -> String {
        guard let hash = tx.hash?.toHexString() else {
            throw ServiceError.wrongSignedTx
        }
        return hash
    }
}
