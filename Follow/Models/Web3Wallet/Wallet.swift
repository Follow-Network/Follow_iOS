//
//  Wallet.swift
//  Follow
//
//  Created by Anton on 06/05/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import web3swift

class Wallet {
    let address: EthereumAddress
    let data: Data
    let isHD: Bool
    
    public init(address: String,
                data: Data,
                isHD: Bool) {
        if let ethAddr = EthereumAddress(address) {
            self.address = ethAddr
            self.data = data
            self.isHD = isHD
        } else {
            fatalError("Wrong wallet address")
        }
    }
    
    public init(address: EthereumAddress,
                data: Data,
                isHD: Bool) {
        self.address = address
        self.data = data
        self.isHD = isHD
    }
    
    public init(wallet: Wallet) {
        self.address = wallet.address
        self.data = wallet.data
        self.isHD = wallet.isHD
    }
}

extension Wallet: Equatable {
    public static func ==(lhs: Wallet, rhs: Wallet) -> Bool {
        return lhs.address == rhs.address
    }
}
