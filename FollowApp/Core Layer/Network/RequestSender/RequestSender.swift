//
//  RequestSender.swift
//  FollowApp
//
//  Created by Георгий Фесенко on 23/11/2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation

final class RequestSender: IRequestSender {
    
    // MARK: - Private properties
    
    private let session = URLSession.shared
    
    
    // MARK: - Public methods
    
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model>) -> Void) {
        
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.error("url string can't be parsed to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(Result.error(error.localizedDescription))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(Result.error("There is no data in the responce"))
                }
                return
            }
            
            guard let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                DispatchQueue.main.async {
                    completionHandler(Result.error("data can't be parsed"))
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(Result.success(parsedModel))
            }
        }
        
        task.resume()
    }
}
