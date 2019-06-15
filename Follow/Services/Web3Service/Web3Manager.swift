//
//  Web3Service.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking
import web3swift

fileprivate enum Web3Service: ResourceType {
    
    case sendRawTx(withHash: String)
    case getEthBalance(forAddress: String)
    
    var baseURL: URL {
        let urlString = Constants.FollowSettings.https +
            Constants.FollowSettings.mainnetInfura
        guard let url = URL(string: urlString) else {
            fatalError("FAILED: \(urlString)")
        }
        return url
    }
    
    var endpoint: Endpoint {
        return .post(path: "/\(Constants.FollowSettings.infuraProjectId)")
    }
    
    var task: Task {
        switch self {
        case let .sendRawTx(withHash: hash):
            var params: [String: Any] = [:]
            
            params["jsonrpc"] = "2.0"
            params["method"] = "eth_sendRawTransaction"
            params["params"] = hash
            params["id"] = 1
            
            return .requestWithParameters(params, encoding: URLEncoding())
        case let .getEthBalance(forAddress: address):
            var params: [String: Any] = [:]
            
            params["jsonrpc"] = "2.0"
            params["method"] = "eth_getBalance"
            params["params"] = [address, "latest"]
            params["id"] = 1
            
            return .requestWithParameters(params, encoding: URLEncoding())
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
}

class Web3Manager: Web3ServiceType {
//    Constants.FollowSettings.wallet.address
    
    // MARK: Private Properties
    private let service: TinyNetworking<Web3Service>
    
    static var shared: Web3Manager {
        return Web3Manager()
    }
    
    // MARK: Public Properties
    public var wallet: Wallet? {
        return Constants.FollowSettings.wallet
    }
    
    public var walletAddress: EthereumAddress? {
        return Constants.FollowSettings.wallet?.address
    }
    
    // MARK: Init
    fileprivate init(service: TinyNetworking<Web3Service> = TinyNetworking<Web3Service>()) {
        self.service = service
    }
    
    // MARK: Public
    public func setCurrentWallet(_ wallet: Wallet) {
        Constants.FollowSettings.wallet = wallet
    }
    
    public func removeCurrentWallet() {
        Constants.FollowSettings.wallet = nil
    }
    
    public func sendRawTx(hash: String) -> Observable<Result<JSONResponse, ServiceError>> {
        return service.rx.request(resource: .sendRawTx(withHash: hash)
            )
            .map(to: JSONResponse.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't send tx: \(hash)")))
            }
            .asObservable()
    }
    
    public func getEthBalance(address: String) -> Observable<Result<JSONResponse, ServiceError>> {
        return service.rx.request(resource: .getEthBalance(forAddress: address)
            )
            .map(to: JSONResponse.self)
            .map(Result.success)
            .catchError { error in
                return .just(.error(.error(withMessage: "Can't get balance for account: \(address)")))
            }
            .asObservable()
    }
}

