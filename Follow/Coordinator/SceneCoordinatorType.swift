//
//  SceneCoordinatorType.swift
//  Follow
//
//  Created by Anton on 19/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    @discardableResult func transition(to scene: TargetScene) -> Observable<Void>
    @discardableResult func pop(animated: Bool) -> Observable<Void>
}
