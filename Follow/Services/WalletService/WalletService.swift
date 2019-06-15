//
//  WalletService.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import web3swift

class WalletService {
    public static func getKeystoreManager(wallet: Wallet) throws -> KeystoreManager {
        if wallet.isHD {
            guard let keystore = BIP32Keystore(wallet.data) else {
                guard let defaultManager = KeystoreManager.defaultManager else {
                    throw WalletError.wrongPKdata
                }
                return defaultManager
            }
            return KeystoreManager([keystore])
        } else {
            guard let keystore = EthereumKeystoreV3(wallet.data) else {
                guard let defaultManager = KeystoreManager.defaultManager else {
                    throw WalletError.wrongPKdata
                }
                return defaultManager
            }
            return KeystoreManager([keystore])
        }
    }
    
    public static func getPrivateKey(wallet: Wallet, password: String) throws -> String {
        do {
            let ethereumAddress = wallet.address
            let manager = try getKeystoreManager(wallet: wallet)
            let pkData = try manager.UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress)
            return pkData.toHexString()
        } catch let error {
            throw error
        }
    }
}
