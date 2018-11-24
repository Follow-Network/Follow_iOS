//
//  Web3Service.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation
import Web3swift
import BigInt
import EthereumAddress

protocol IWeb3Service {
    func writeTransaction(transaction: WriteTransaction, password: String, completion: @escaping (Result<TransactionSendingResult>) -> Void)
    func callTransaction(transaction: ReadTransaction, password: String, completion: @escaping (Result<[String : Any]>) -> Void)
    func getETHbalance(completion: @escaping (Result<String>) -> Void)
    func getERCBalance(tokenAddress: String,
                       completion: @escaping (Result<String>) -> Void)
    func defaultOptions() -> TransactionOptions
    func contract(for address: String) -> web3.web3contract
}

class Web3Service: IWeb3Service {
    
    static var web3Instance: web3 {
        let web3 = Web3.InfuraMainnetWeb3()
        web3.addKeystoreManager(KeysService().keystoreManager())
        return web3
    }
    
    static var currentAddress: EthereumAddress {
        let wallet = KeysService().getWallet()
        let address = wallet?.address
        let ethAddressFrom = EthereumAddress(address!)!
        return ethAddressFrom
    }
    
    public func writeTransaction(transaction: WriteTransaction, password: String, completion: @escaping (Result<TransactionSendingResult>) -> Void) {
        DispatchQueue.global().async {
            guard let result = try? transaction.send(password: password, transactionOptions: nil) else {
                DispatchQueue.main.async {
                    completion(Result.error(NetworkErrors.cantSentTransaction))
                }
                return
            }
            DispatchQueue.main.async {
                completion(Result.success(result))
            }
        }
    }
    
    func callTransaction(transaction: ReadTransaction, password: String, completion: @escaping (Result<[String : Any]>) -> Void) {
        DispatchQueue.global().async {
            guard let result = try? transaction.call() else {
                DispatchQueue.main.async {
                    completion(Result.error(NetworkErrors.cantSentTransaction))
                }
                return
            }
            DispatchQueue.main.async {
                completion(Result.success(result))
            }
        }
    }
    
    public func getETHbalance(completion: @escaping (Result<String>) -> Void) {
        DispatchQueue.global().async {
            let address = Web3Service.currentAddress
            let web3 = Web3Service.web3Instance
            guard let balanceResult = try? web3.eth.getBalance(address: address) else {
                DispatchQueue.main.async {
                    completion(Result.error(Web3Error.connectionError))
                }
                return
            }
            guard let balanceString = Web3.Utils.formatToEthereumUnits(balanceResult, toUnits: .eth, decimals: 3) else {
                DispatchQueue.main.async {
                    completion(Result.error(Web3Error.dataError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(Result.success(balanceString))
            }
        }
    }
    
    public func getERCBalance(tokenAddress: String,
                              completion: @escaping (Result<String>) -> Void) {
        DispatchQueue.global().async {
            let contract = self.contract(for: tokenAddress)
            let options = self.defaultOptions()
            let userAddress = Web3Service.currentAddress
            guard let readTX = contract.read("balanceOf", parameters: [userAddress] as [AnyObject]) else {
                DispatchQueue.main.async {
                    completion(Result.error(Web3Error.transactionSerializationError))
                }
                return
            }
            guard let tokenBalance = try? readTX.call(transactionOptions: options) else {
                DispatchQueue.main.async {
                    completion(Result.error(NetworkErrors.cantSentTransaction))
                }
                return
            }
            guard let balance = tokenBalance["0"] as? BigUInt else {
                DispatchQueue.main.async {
                    completion(Result.error(Web3Error.dataError))
                }
                return
            }
            guard let balanceString = Web3.Utils.formatToEthereumUnits(balance, toUnits: .eth, decimals: 3) else {
                DispatchQueue.main.async {
                    completion(Result.error(Web3Error.dataError))
                }
                return
            }
            DispatchQueue.main.async {
                completion(Result.success(balanceString))
            }
        }
    }
    
    public func contract(for address: String) -> web3.web3contract {
        let web3 = Web3Service.web3Instance
        let ethAddress = EthereumAddress(address)!
        return web3.contract(Web3.Utils.erc20ABI, at: ethAddress, abiVersion: 2)!
    }
    
    public func defaultOptions() -> TransactionOptions {
        var options = TransactionOptions.defaultOptions
        let address = Web3Service.currentAddress
        options.from = address
        return options
    }
    
}
