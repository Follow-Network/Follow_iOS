//
//  WalletManagerHelpers.swift
//  Follow
//
//  Created by Anton on 15/06/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import web3swift

func generateMnemonics(bitsOfEntropy: Int) throws -> Mnemonic {
    guard let mnemonics = try? BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy) else {
        throw Web3Error.keystoreError(err: .noEntropyError)
    }
    return mnemonics
}
