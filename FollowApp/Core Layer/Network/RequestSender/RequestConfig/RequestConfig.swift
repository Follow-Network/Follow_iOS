//
//  RequestConfig.swift
//  FollowApp
//
//  Created by Георгий Фесенко on 23/11/2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}
