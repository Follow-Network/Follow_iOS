//
//  WalletError.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation

enum WalletError: Error {
    case wrongMMdata
    case wrongPKdata
    case wrongAddressesCount
    case cantEncode
    case storageError
    case unknown
}
