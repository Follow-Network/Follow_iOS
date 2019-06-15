//
//  WalletManager.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import web3swift

public typealias Mnemonic = String

class WalletManager {
    
    private static var _currentWallet: Wallet?
    private static let walletService = WalletService()
    
    public class var currentWallet: Wallet? {
        get {
            if let wallet = _currentWallet {
                return wallet
            }
            if let savedWallet = try? getSavedWallet() {
                _currentWallet = savedWallet
                return savedWallet
            } else {
                return nil
            }
        }
        set(wallet) {
            if let wallet = wallet {
                do {
                    try saveWallet(wallet)
                    _currentWallet = wallet
                } catch let error {
                    fatalError("Can't set wallet \(wallet.address), error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private static func getSavedWallet() throws -> Wallet {
        throw WalletError.unknown
    }
    
    private static func saveWallet(_ wallet: Wallet) throws {
        
    }
    
    private static func saveMnemonic(_ mnemonic: Mnemonic) throws {
        
    }
    
    public static func importWalletWithPrivateKey(key: String,
                                           password: String) throws {
        let text = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data = Data.fromHex(text) else {
            throw WalletError.wrongPKdata
        }
        
        guard let wallet = try? EthereumKeystoreV3(privateKey: data, password: password) else {
            throw WalletError.wrongPKdata
        }
        
        guard wallet.addresses?.count == 1, let address = wallet.addresses?.first else {
            throw WalletError.wrongAddressesCount
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {
            throw WalletError.cantEncode
        }
        WalletManager.currentWallet = Wallet(address: address,
                                             data: keyData,
                                             isHD: false)
    }
    
    public static func createWallet(password: String) throws {
        guard let wallet = try? EthereumKeystoreV3(password: password) else {
            throw WalletError.unknown
        }
        guard wallet.addresses?.count == 1, let address = wallet.addresses?.first else {
            throw WalletError.wrongAddressesCount
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {
            throw WalletError.cantEncode
        }
        WalletManager.currentWallet = Wallet(address: address,
                                             data: keyData,
                                             isHD: false)
    }
    
    public static func importHDWallet(password: String,
                               mnemonics: String) throws {
        guard let wallet = try? BIP32Keystore(mnemonics: mnemonics,
                                              password: password,
                                              mnemonicsPassword: "",
                                              language: .english) else {
            throw WalletError.wrongMMdata
        }
        guard wallet.addresses?.count == 1, let address = wallet.addresses?.first else {
            throw WalletError.wrongAddressesCount
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {
            throw WalletError.cantEncode
        }
        guard ((try? saveMnemonic(mnemonics)) != nil) else {
            throw WalletError.storageError
        }
        WalletManager.currentWallet = Wallet(address: address,
                                             data: keyData,
                                             isHD: true)
    }
    
    public static func createHDWallet(password: String) throws {
        guard let mnemonics = try? generateMnemonics(bitsOfEntropy: 128) else {
            throw WalletError.unknown
        }
        guard let wallet = try? BIP32Keystore(mnemonics: mnemonics,
                                              password: password,
                                              mnemonicsPassword: "",
                                              language: .english) else {
                                                throw WalletError.wrongMMdata
        }
        guard wallet.addresses?.count == 1, let address = wallet.addresses?.first else {
            throw WalletError.wrongAddressesCount
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {
            throw WalletError.cantEncode
        }
        guard ((try? saveMnemonic(mnemonics)) != nil) else {
            throw WalletError.storageError
        }
        WalletManager.currentWallet = Wallet(address: address,
                                             data: keyData,
                                             isHD: true)
    }
}
