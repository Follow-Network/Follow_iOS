//
//  PhotoServiceType.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift

protocol ContentServiceType {
    func likeImage(image: Image) ->  Observable<Result<Image, ServiceError>>
    func unlikeImage(image: Image) ->  Observable<Result<Image, ServiceError>>
    func likePost(post: Post) ->  Observable<Result<Post, ServiceError>>
    func unlikePost(post: Post) ->  Observable<Result<Post, ServiceError>>
}
