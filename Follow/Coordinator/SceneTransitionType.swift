//
//  SceneTransitionType.swift
//  Follow
//
//  Created by Anton on 19/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit

enum SceneTransitionType {
    // you can extend this to add animated transition types,
    // interactive transitions and even child view controllers!
    
    case root(UIViewController)       // make view controller the root view controller.
    case push(UIViewController)       // push view controller to navigation stack.
    case present(UIViewController)    // present view controller.
    case alert(UIViewController)      // present alert.
    case tabBar(UITabBarController)   // make tab bar controller the root controller.
}