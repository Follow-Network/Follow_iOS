//
//  Web3ServiceType.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift

protocol Web3ServiceType {
    func setCurrentWallet(_ wallet: Wallet)
    func removeCurrentWallet()
    func sendRawTx(hash: String) -> Observable<Result<JSONResponse, ServiceError>>
    func getEthBalance(address: String) -> Observable<Result<JSONResponse, ServiceError>>
}
