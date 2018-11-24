//
//  ConversionService.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import UIKit
import Alamofire

protocol IConversionService {
    func updateConversionRate(for tokenName: String, completion: @escaping (Double) -> Void)
    func currentConversionRate(for tokenName: String) -> Double
}

class ConversionService: IConversionService {
    
    static let service = ConversionService()
    var conversionRates = [String: Double]()
    
    let urlFormat = URLs.pricesFromCryptocompare
    
    func updateConversionRate(for tokenName: String, completion: @escaping (Double) -> Void) {
        
        let fullURLString = String(format: urlFormat, tokenName)
        
        guard let url = URL(string: fullURLString) else {
            completion(0)
            return
        }
        
        Alamofire.request(url)
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print(response.result.error!.localizedDescription)
                    DispatchQueue.main.async {
                        completion(0)
                    }
                    return
                }
                guard let value = response.result.value as? [String: Any],
                    let conversionRate = value["USD"] as? Double else {
                        print("Can't convert to Double")
                        DispatchQueue.main.async {
                            completion(0)
                        }
                        return
                }
                
                self.conversionRates[tokenName] = conversionRate
                completion(conversionRate)
        }
    }
    
    func currentConversionRate(for tokenName: String) -> Double {
        return conversionRates[tokenName] ?? 0
    }
}
