//
//  KeyWalletModel.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation

struct KeyWalletModel {
    let address: String
    let data: Data?
    let isHD: Bool
    
    static func fromCoreData(crModel: KeyWallet) -> KeyWalletModel {
        let model = KeyWalletModel(address: crModel.address ?? "",
                                   data: crModel.data,
                                   isHD: crModel.isHD)
        return model
    }
}

extension KeyWalletModel: Equatable {
    static func ==(lhs: KeyWalletModel, rhs: KeyWalletModel) -> Bool {
        return lhs.address == rhs.address && lhs.data == rhs.data
    }
}

struct HDKey {
    let address: String
}
