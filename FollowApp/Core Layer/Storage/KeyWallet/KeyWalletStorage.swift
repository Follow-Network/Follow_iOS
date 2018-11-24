//
//  KeyWalletStorage.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation
import CoreData

protocol IKeyWalletStorage {
    func getWallet() -> KeyWalletModel?
    func saveWallet(wallet: KeyWalletModel?, completion: @escaping (Error?) -> Void)
    func deleteWallet(completion: @escaping (Error?) -> Void)
    func getAllWallets() -> [KeyWalletModel]
    func deleteWallet(wallet: KeyWalletModel, completion: @escaping (Error?) -> Void)
}

class KeyWalletStorage: IKeyWalletStorage {
    lazy var container: NSPersistentContainer = NSPersistentContainer(name: "CoreDataModel")
    private lazy var mainContext = self.container.viewContext
    
    init() {
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
    }
    
    public func getWallet() -> KeyWalletModel? {
        let requestWallet: NSFetchRequest<KeyWallet> = KeyWallet.fetchRequest()
        requestWallet.predicate = NSPredicate(format: "isSelected = %@", NSNumber(value: true))
        do {
            let results = try mainContext.fetch(requestWallet)
            guard let result = results.first else {
                return nil
            }
            return KeyWalletModel.fromCoreData(crModel: result)
            
        } catch {
            print(error)
            return nil
        }
        
    }
    
    public func getAllWallets() -> [KeyWalletModel] {
        let requestWallet: NSFetchRequest<KeyWallet> = KeyWallet.fetchRequest()
        do {
            let results = try mainContext.fetch(requestWallet)
            return results.map {
                return KeyWalletModel.fromCoreData(crModel: $0)
            }
            
        } catch {
            print(error)
            return []
        }
    }
    
    public func saveWallet(wallet: KeyWalletModel?, completion: @escaping (Error?) -> Void) {
        container.performBackgroundTask { (context) in
            guard let wallet = wallet else {
                return
            }
            guard let entity = NSEntityDescription.insertNewObject(forEntityName: "KeyWallet", into: context) as? KeyWallet else {
                return
            }
            entity.address = wallet.address
            entity.data = wallet.data
            entity.isHD = wallet.isHD
            do {
                try context.save()
                completion(nil)
                
            } catch {
                completion(error)
            }
        }
    }
    
    public func deleteWallet(completion: @escaping (Error?) -> Void) {
        let requestWallet: NSFetchRequest<KeyWallet> = KeyWallet.fetchRequest()
        do {
            let results = try mainContext.fetch(requestWallet)
            
            for item in results {
                mainContext.delete(item)
            }
            try mainContext.save()
            completion(nil)
            
        } catch {
            completion(error)
        }
    }
    
    public func deleteWallet(wallet: KeyWalletModel, completion: @escaping (Error?) -> Void) {
        let requestWallet: NSFetchRequest<KeyWallet> = KeyWallet.fetchRequest()
        requestWallet.predicate = NSPredicate(format: "address = %@", wallet.address)
        do {
            let results = try mainContext.fetch(requestWallet)
            guard let result = results.first else {
                completion(StorageErrors.noSuchWalletInStorage)
                return
            }
            mainContext.delete(result)
            try mainContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func fetchWalletRequest(withAddress address: String) -> NSFetchRequest<KeyWallet> {
        let fr: NSFetchRequest<KeyWallet> = KeyWallet.fetchRequest()
        fr.predicate = NSPredicate(format: "address = %@", address)
        return fr
    }
    
}
