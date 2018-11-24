//
//  TokensService.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation
import Web3swift
import Alamofire
import BigInt
import EthereumAddress

protocol ITokensService {
    func getFullTokensList(for searchString: String, completion: @escaping (Result<[ERC20TokenModel]>) -> Void)
    func downloadAllAvailableTokensIfNeeded(completion: @escaping (Error?) -> Void)
}

class TokensService {
    
    let web3service = Web3Service()
    
    let conversionService = ConversionService.service
    
    public func getFullTokensList(for searchString: String, completion: @escaping (Result<[ERC20TokenModel]>) -> Void) {
        var tokensList: [ERC20TokenModel] = []
        DispatchQueue.global().async {
            let tokensFromCD = TokensStorage().getTokensList(for: searchString)
            if let tokens = tokensFromCD {
                if tokens.count != 0 {
                    DispatchQueue.main.async {
                        for token in tokens {
                            let tokenModel = ERC20TokenModel(name: token.name,
                                                             address: token.address,
                                                             decimals: token.decimals,
                                                             symbol: token.symbol)
                            tokensList.append(tokenModel)
                        }
                        completion(Result.success(tokensList))
                    }
                    
                } else {
                    self.getOnlineTokensList(with: searchString, completion: { (result) in
                        switch result {
                        case .success(let list):
                            DispatchQueue.main.async {
                                completion(Result.success(list))
                            }
                        case .error(let error):
                            completion(Result.error(error))
                        }
                    })
                }
            } else {
                self.getOnlineTokensList(with: searchString, completion: { (result) in
                    switch result {
                    case .success(let list):
                        DispatchQueue.main.async {
                            completion(Result.success(list))
                        }
                    case .error(let error):
                        completion(Result.error(error))
                    }
                })
            }
        }
        
    }
    
    private func name(for token: String, completion: @escaping (Result<String>) -> Void) {
        let contract = web3service.contract(for: token)
        let options = web3service.defaultOptions()
        guard let transaction = contract.read("name", parameters: [AnyObject](), extraData: Data(), transactionOptions: web3service.defaultOptions()) else {
            completion(Result.error(Web3Error.transactionSerializationError))
            return
        }
        guard let result = try? transaction.call(transactionOptions: options) else {
            completion(Result.error(NetworkErrors.cantSentTransaction))
            return
        }
        if let name = result["0"] as? String, !name.isEmpty {
            completion(Result.success(name))
        } else {
            completion(Result.error(Web3Error.dataError))
        }
    }
    
    private func symbol(for token: String, completion: @escaping (Result<String>) -> Void) {
        let contract = web3service.contract(for: token)
        let options = web3service.defaultOptions()
        guard let transaction = contract.read("symbol", parameters: [AnyObject](), extraData: Data(), transactionOptions: web3service.defaultOptions()) else {
            completion(Result.error(Web3Error.transactionSerializationError))
            return
        }
        guard let result = try? transaction.call(transactionOptions: options) else {
            completion(Result.error(NetworkErrors.cantSentTransaction))
            return
        }
        if let name = result["0"] as? String, !name.isEmpty {
            completion(Result.success(name))
        } else {
            completion(Result.error(Web3Error.dataError))
        }
    }
    
    private func decimals(for token: String, completion: @escaping (Result<BigUInt>) -> Void) {
        let contract = web3service.contract(for: token)
        let options = web3service.defaultOptions()
        guard let transaction = contract.read("decimals", parameters: [AnyObject](), extraData: Data(), transactionOptions: web3service.defaultOptions()) else {
            completion(Result.error(Web3Error.transactionSerializationError))
            return
        }
        guard let result = try? transaction.call(transactionOptions: options) else {
            completion(Result.error(NetworkErrors.cantSentTransaction))
            return
        }
        if let name = result["0"] as? BigUInt, name != 0 {
            completion(Result.success(name))
        } else {
            completion(Result.error(Web3Error.dataError))
        }
    }
    
    private func getOnlineTokensList(with address: String, completion: @escaping (Result<[ERC20TokenModel]>) -> Void) {
        
        guard EthereumAddress(address) != nil else {
            completion(Result.error(Web3Error.dataError))
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        var name: String = ""
        self.name(for: address, completion: { (result) in
            switch result {
            case .success(let localName):
                name = localName
            case .error(let error):
                completion(Result.error(error))
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        var decimals: BigUInt = BigUInt()
        self.decimals(for: address, completion: { (result) in
            switch result {
            case .success(let localDecimals):
                decimals = localDecimals
            case .error(let error):
                completion(Result.error(error))
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.enter()
        var symbol: String = ""
        self.symbol(for: address, completion: { (result) in
            switch result {
            case .success(let localSymbol):
                symbol = localSymbol
            case .error(let error):
                completion(Result.error(error))
            }
            dispatchGroup.leave()
        })
        
        dispatchGroup.notify(queue: .main) {
            completion(Result.success([ERC20TokenModel(name: name,
                                                       address: address,
                                                       decimals: decimals.description,
                                                       symbol: symbol)]))
        }
    }
    
    public func downloadAllAvailableTokensIfNeeded(completion: @escaping (Error?) -> Void) {
        
        guard let url = URL(string: URLs.downloadTokensList) else {
            DispatchQueue.main.async {
                completion(NetworkErrors.wrongURL)
            }
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            guard response.result.isSuccess else {
                DispatchQueue.main.async {
                    completion(response.result.error!)
                }
                return
            }
            
            guard response.data != nil else {
                DispatchQueue.main.async {
                    completion(response.result.error!)
                }
                return
            }
            guard let value = response.result.value as? [[String: Any]] else {
                DispatchQueue.main.async {
                    completion(response.result.error!)
                }
                return
            }
            let dictsCount = value.count
            var counter = 0
            value.forEach({ (dict) in
                counter += 1
                TokensStorage().saveToken(from: dict, completion: {(_) in
                    if counter == dictsCount {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                })
            })
        }
    }
    
    func updateConversion(for token: ERC20TokenModel, completion: @escaping (Double?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.conversionService.updateConversionRate(for: token.symbol.uppercased()) { (rate) in
                DispatchQueue.main.async {
                    completion(rate)
                }
            }
        }
    }
    
}
