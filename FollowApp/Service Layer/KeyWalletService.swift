//
//  KeyWalletService.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation
import Web3swift
import BigInt
import EthereumAddress

protocol IKeysService {
    func getWallet() -> KeyWalletModel?
    func getKey() -> HDKey?
    func keystoreManager() -> KeystoreManager
    func importWalletWithPrivateKey(key: String,
                                    password: String,
                                    completion: @escaping (KeyWalletModel?, Error?) -> Void)
    func createWallet(password: String,
                      completion: @escaping (KeyWalletModel?, Error?) -> Void)
    func createHDWallet(password: String,
                        mnemonics: String,
                        completion: @escaping (KeyWalletModel?, Error?) -> Void)
    func getWalletPrivateKey(for wallet: KeyWalletModel, password: String) -> String?
    func getPrivateKey(for wallet: KeyWalletModel, password: String) -> String?
    func generateMnemonics(bitsOfEntropy: Int) -> String
}

class KeysService: IKeysService {
    
    let walletStorage = KeyWalletStorage()
    
    public func getWallet() -> KeyWalletModel? {
        return walletStorage.getWallet()
    }
    
    public func getKey() -> HDKey? {
        guard let wallet = getWallet(), !wallet.address.isEmpty else {
            return nil
        }
        return HDKey(address: wallet.address)
    }
    
    public func keystoreManager() -> KeystoreManager {
        guard let wallet = getWallet(), let data = wallet.data else {
            return KeystoreManager.defaultManager!
        }
        if wallet.isHD {
            return KeystoreManager([BIP32Keystore(data)!])
        } else {
            return KeystoreManager([EthereumKeystoreV3(data)!])
        }
    }
    
    public func importWalletWithPrivateKey(key: String,
                                           password: String,
                                           completion: @escaping (KeyWalletModel?, Error?) -> Void) {
        let text = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let data = Data.fromHex(text) else {
            completion(nil, StorageErrors.couldNotImportTheWallet)
            return
        }
        
        guard let newWallet = try? EthereumKeystoreV3(privateKey: data, password: password) else {
            completion(nil, StorageErrors.couldNotImportTheWallet)
            return
        }
        
        guard let wallet = newWallet, wallet.addresses?.count == 1 else {
            completion(nil, StorageErrors.couldNotImportTheWallet)
            return
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {
            completion(nil, StorageErrors.couldNotImportTheWallet)
            return
        }
        guard let address = newWallet?.addresses?.first?.address else {
            completion(nil, StorageErrors.couldNotImportTheWallet)
            return
        }
        let walletModel = KeyWalletModel(address: address, data: keyData, isHD: false)
        completion(walletModel, nil)
    }
    
    public func createWallet(password: String,
                             completion: @escaping (KeyWalletModel?, Error?) -> Void) {
        guard let newWallet = try? EthereumKeystoreV3(password: password) else {
            completion(nil, StorageErrors.couldNotCreateTheWallet)
            return
        }
        guard let wallet = newWallet, wallet.addresses?.count == 1 else {
            completion(nil, StorageErrors.couldNotCreateTheWallet)
            return
        }
        guard let keydata = try? JSONEncoder().encode(wallet.keystoreParams) else {
            completion(nil, StorageErrors.couldNotCreateTheWallet)
            return
        }
        guard let address = wallet.addresses?.first?.address else {
            completion(nil, StorageErrors.couldNotCreateTheWallet)
            return
        }
        let walletModel = KeyWalletModel(address: address, data: keydata, isHD: false)
        completion(walletModel, nil)
    }
    
    func createHDWallet(password: String, mnemonics: String, completion: @escaping (KeyWalletModel?, Error?) -> Void) {
        guard let keystore = try? BIP32Keystore(mnemonics: mnemonics,
                                                password: password,
                                                mnemonicsPassword: "",
                                                language: .english), let wallet = keystore else {
                                                    return
        }
        guard let address = wallet.addresses?.first?.address else {
            completion(nil, StorageErrors.couldNotCreateTheWallet)
            return
        }
        guard let keyData = try? JSONEncoder().encode(wallet.keystoreParams) else {
            completion(nil, StorageErrors.couldNotCreateTheWallet)
            return
        }
        let walletModel = KeyWalletModel(address: address, data: keyData, isHD: true)
        completion(walletModel, nil)
    }
    
    public func getWalletPrivateKey(for wallet: KeyWalletModel, password: String) -> String? {
        do {
            let data = try keystoreManager().UNSAFE_getPrivateKeyData(password: password, account: EthereumAddress((wallet.address))!)
            return data.toHexString()
        } catch {
            print(error)
            return nil
        }
    }
    
    public func getPrivateKey(for wallet: KeyWalletModel, password: String) -> String? {
        do {
            guard let ethereumAddress = EthereumAddress(wallet.address) else {
                return nil
            }
            let pkData = try keystoreManager().UNSAFE_getPrivateKeyData(password: password, account: ethereumAddress)
            return pkData.toHexString()
        } catch {
            print(error)
            return nil
        }
    }
    
    public func generateMnemonics(bitsOfEntropy: Int) -> String {
        guard let mnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy),
            let unwrapped = mnemonics else {
                return ""
        }
        return unwrapped
    }
}
