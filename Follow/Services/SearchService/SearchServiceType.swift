//
//  SearchServiceType.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift

protocol SearchServiceType {
    func searchTraders(with query: String, page: UInt64?, orderBy: TradersOrderBy?) -> Observable<Result<[User], ServiceError>>
    func getTraders(page: UInt64?, orderBy: TradersOrderBy?) -> Observable<Result<[User], ServiceError>>
}
