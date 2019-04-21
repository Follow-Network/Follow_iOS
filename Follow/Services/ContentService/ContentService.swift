//
//  PhotoService.swift
//  Follow
//
//  Created by Anton on 21/04/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import Foundation
import RxSwift
import TinyNetworking

struct ContentService: ContentServiceType {

    private let service: TinyNetworking<Follow>
    private let cache: Cache
    
    init(service: TinyNetworking<Follow> = TinyNetworking<Follow>(),
         cache: Cache = Cache.shared) {
        self.service = service
        self.cache = cache
    }

    func likeImage(image: Image) ->  Observable<Result<Image, ServiceError>> {
        return service.rx
            .request(resource: .likeImage(id: image.id))
            .map(to: LikeUnlikeImage.self)
            .map { $0.image }
            .asObservable()
            .unwrap()
            .flatMapIgnore { Observable.just(self.cache.set(value: $0)) } // 🎡 Update cache
            .map(Result.success)
            .catchError { _ in
                return .just(.error(.error(withMessage: "Can't like image")))
            }
    }
    
    func unlikeImage(image: Image) ->  Observable<Result<Image, ServiceError>> {
        return service.rx
            .request(resource: .unlikeImage(id: image.id))
            .map(to: LikeUnlikeImage.self)
            .map { $0.image }
            .asObservable()
            .unwrap()
            .flatMapIgnore { Observable.just(self.cache.set(value: $0)) } // 🎡 Update cache
            .map(Result.success)
            .catchError { _ in
                return .just(.error(.error(withMessage: "Can't unlike image")))
        }
    }
    
    func likePost(post: Post) ->  Observable<Result<Post, ServiceError>> {
        return service.rx
            .request(resource: .likePost(userId: post.user.id, postId: post.id))
            .map(to: LikeUnlikePost.self)
            .map { $0.post }
            .asObservable()
            .unwrap()
            .flatMapIgnore { Observable.just(self.cache.set(value: $0)) } // 🎡 Update cache
            .map(Result.success)
            .catchError { _ in
                return .just(.error(.error(withMessage: "Can't like post")))
        }
    }
    
    func unlikePost(post: Post) ->  Observable<Result<Post, ServiceError>> {
        return service.rx
            .request(resource: .unlikePost(userId: post.user.id, postId: post.id))
            .map(to: LikeUnlikePost.self)
            .map { $0.post }
            .asObservable()
            .unwrap()
            .flatMapIgnore { Observable.just(self.cache.set(value: $0)) } // 🎡 Update cache
            .map(Result.success)
            .catchError { _ in
                return .just(.error(.error(withMessage: "Can't unlike post")))
        }
    }
}
