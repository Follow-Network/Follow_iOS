//
//  TokensStorage.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation
import CoreData

protocol ITokensStorage {
    func getAllTokens(for wallet: KeyWalletModel, forNetwork: Int64) -> [ERC20TokenModel]
    func saveCustomToken(with token: ERC20TokenModel?, forWallet: KeyWalletModel, forNetwork: Int64, completion: @escaping(Error?) -> Void)
    func getToken(token: ERC20TokenModel?) -> ERC20TokenModel?
    func getTokensList(for searchingString: String) -> [ERC20TokenModel]?
    func deleteToken(token: ERC20TokenModel, forWallet: KeyWalletModel, forNetwork: Int64, completion: @escaping (Error?) -> Void)
}


class TokensStorage: ITokensStorage {
    
    lazy var container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataModel")
    private lazy var mainContext = self.container.viewContext
    
    init() {
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }
    
    public func saveToken(from dict: [String: Any], completion: @escaping(Error?) -> Void) {
        
        container.performBackgroundTask { (context) in
            
            do {
                let token: NSFetchRequest<ERC20Token> = ERC20Token.fetchRequest()
                guard let address = dict["address"] as? String else {
                    completion(nil)
                    return
                }
                token.predicate = NSPredicate(format: "address = %@", address)
                
                guard var newToken = NSEntityDescription.insertNewObject(forEntityName: "ERC20Token", into: context) as? ERC20Token else {
                    return
                }
                
                if let entity = try self.mainContext.fetch(token).first {
                    newToken = entity
                }
                
                newToken.address = dict["address"] as? String
                newToken.symbol = dict["symbol"] as? String
                newToken.name = newToken.symbol
                newToken.decimals = String((dict["decimal"] as? Int) ?? 0)
                newToken.networkID = 0
                newToken.isAdded = false
                
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func saveCustomToken(with token: ERC20TokenModel?,
                                forWallet: KeyWalletModel,
                                forNetwork: Int64,
                                completion: @escaping(Error?) -> Void) {
        
        container.performBackgroundTask { (context) in
            do {
                guard let token = token else {
                    completion(NetworkErrors.couldnotParseJSON)
                    return
                }
                guard let entity = NSEntityDescription.insertNewObject(forEntityName: "ERC20Token",
                                                                       into: context) as? ERC20Token else {
                                                                        completion(NetworkErrors.couldnotParseJSON)
                                                                        return
                }
                entity.address = token.address
                entity.name = token.name
                entity.symbol = token.symbol
                entity.decimals = token.decimals
                entity.isAdded = true
                let networkID = forNetwork
                entity.networkID = networkID
                
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func getAllTokens(for wallet: KeyWalletModel, forNetwork: Int64) -> [ERC20TokenModel] {
        do {
            let requestTokens: NSFetchRequest<ERC20Token> = ERC20Token.fetchRequest()
            let networkID = forNetwork
            //let networkID: Int64 = Int64(String(CurrentNetwork.currentNetwork?.chainID ?? 0)) ?? 0
            
            requestTokens.predicate = NSPredicate(format:
                "networkID == %@ && isAdded == %@",
                                                  NSNumber(value: networkID),
                                                  NSNumber(value: true)
            )
            let results = try mainContext.fetch(requestTokens)
            return results.map {
                return ERC20TokenModel.fromCoreData(crModel: $0)
            }
            
        } catch {
            print(error)
            return []
        }
    }
    
    public func getAllTokens() -> [ERC20TokenModel]? {
        let requestToken: NSFetchRequest<ERC20Token> = ERC20Token.fetchRequest()
        requestToken.predicate = NSPredicate(format: "walletAddress = %@", "")
        do {
            let results = try mainContext.fetch(requestToken)
            return results.map {
                return ERC20TokenModel.fromCoreData(crModel: $0)
            }
        } catch {
            return nil
        }
    }
    
    public func getToken(token: ERC20TokenModel?) -> ERC20TokenModel? {
        let requestToken: NSFetchRequest<ERC20Token> = ERC20Token.fetchRequest()
        requestToken.predicate = NSPredicate(format: "address = %@", (token?.address) ?? "")
        do {
            let results = try mainContext.fetch(requestToken)
            return results.map {
                return ERC20TokenModel.fromCoreData(crModel: $0)
                }.first
        } catch {
            return nil
        }
        
    }
    
    public func getTokensList(for searchingString: String) -> [ERC20TokenModel]? {
        let requestToken: NSFetchRequest<ERC20Token> = ERC20Token.fetchRequest()
        requestToken.predicate = NSPredicate(format:
            "walletAddress = %@ && (address CONTAINS[c] %@ || name CONTAINS[c] %@ || symbol CONTAINS[c] %@)",
                                             "",
                                             searchingString, searchingString, searchingString)
        do {
            let results = try mainContext.fetch(requestToken)
            return results.map {
                return ERC20TokenModel.fromCoreData(crModel: $0)
            }
        } catch {
            return nil
        }
    }
    
    public func deleteToken(token: ERC20TokenModel,
                            forWallet: KeyWalletModel,
                            forNetwork: Int64,
                            completion: @escaping (Error?) -> Void) {
        do {
            let requestToken: NSFetchRequest<ERC20Token> = ERC20Token.fetchRequest()
            requestToken.predicate = NSPredicate(format: "walletAddress = %@", forWallet.address)
            
            let results = try mainContext.fetch(requestToken)
            let tokens = results.filter {
                $0.address == token.address
            }
            let tokensInNetwork = tokens.filter {
                $0.networkID == forNetwork
            }
            guard let token = tokensInNetwork.first else {
                completion(nil)
                return
            }
            mainContext.delete(token)
            try mainContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func fetchTokenRequest(withAddress address: String) -> NSFetchRequest<ERC20Token> {
        let fr: NSFetchRequest<ERC20Token> = ERC20Token.fetchRequest()
        fr.predicate = NSPredicate(format: "address = %@", address)
        return fr
    }
    
}
