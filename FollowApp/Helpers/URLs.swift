//
//  URLs.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation

struct URLs {
    static let pricesFromCryptocompare = "https://min-api.cryptocompare.com/data/price?fsym=%@&tsyms=USD"
    static let downloadTokensList = "https://raw.githubusercontent.com/kvhnuke/etherwallet/mercury/app/scripts/tokens/ethTokens.json"
}

func getURL(forContractAddress: String) -> String {
    return "https://api-rinkeby.etherscan.io/api?module=contract&action=getabi&address=\(forContractAddress)&apikey=YourApiKeyToken"
}
