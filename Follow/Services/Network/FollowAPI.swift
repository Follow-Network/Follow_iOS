//
//  FollowAPI.swift
//  Follow
//
//  Created by Anton Grigorev on 05/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit
import RxSwift

public final class FollowAPI {
    
    // MARK: - Properties
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    private var service: Service?
    
    lazy private var apiKey: String = {
        guard let filePath: String = Bundle.main.path(forResource: "Services", ofType: "plist") else { fatalError("Couldn't find Services.plist") }
        guard let dict = NSDictionary(contentsOfFile: filePath) else { fatalError("Can't read Services.plist") }
        guard let apiKey = dict["FollowAPIKey"] as? String else { fatalError("Couldn't find a value for 'TMDbAPIKey'") }
        return apiKey
    }()
    
    // MARK: - Initializer
    
    init() { }
    
    // MARK: - Service
    
    private func setupService(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Service {
        let urlSession = URLSession.shared
        let defaultParameters = [URLParameter(key: "api_key", value: apiKey)]
        let configuration = ServiceConfiguration(urlScheme: "https", urlHost: "api.thefollow.org", defaultHTTPHeaders: [:], defaultURLParameters: defaultParameters)
        return Service(session: urlSession, configuration: configuration)
    }
    
    // MARK: - Service Follow API start method
    
    public func start(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        service = setupService(with: launchOptions)
        
        // Start updating the API configuration (Every four days)
        // FIXME: - Improve this by performing background fetch
//        let days: RxTimeInterval = 4.0 * 60.0 * 60.0 * 24.0
//        Observable<Int>
//            .timer(0, period: days, scheduler: MainScheduler.instance)
//            .flatMap { (_) -> Observable<APIConfiguration> in
//                return self.configuration()
//            }.map { (apiConfiguration) -> ImageManager in
//                return ImageManager(apiConfiguration: apiConfiguration)
//            }.subscribe(onNext: { (imageManager) in
//                UIImageView.imageManager = imageManager
//            }).disposed(by: self.disposeBag)
    }
}
