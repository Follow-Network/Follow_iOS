//
//  IRequestSender.swift
//  FollowApp
//
//  Created by Георгий Фесенко on 23/11/2018.
//  Copyright © 2018 Follow. All rights reserved.
//
import Foundation

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model>) -> Void)
}
