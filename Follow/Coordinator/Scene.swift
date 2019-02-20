//
//  Scene.swift
//  Follow
//
//  Created by Anton on 19/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit

/**
 Refers to a screen managed by a view controller.
 It can be a regular screen, or a modal dialog.
 It comprises a view controller and a view model.
 */

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case follow
    case login(LoginViewModel)
    case alert(AlertViewModel)
    case activity([Any])
    case userProfile(UserProfileViewModel)
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .follow:
            let followTabBarController = FollowTabBarController()
            
            //HomeViewController
            var tradersVC = TradersViewController(collectionViewLayout: PinterestLayout(numberOfColumns: 1))
            let tradersViewModel = TradersViewModel()
            let rootTradersVC = FollowNavigationController(rootViewController: tradersVC)
            tradersVC.bind(to: tradersViewModel)
            
            //SearchViewController
//            var searchVC = SearchViewController.initFromNib()
//            let searchViewModel = SearchViewModel()
//            let rootSearchVC = PaprNavigationController(rootViewController: searchVC)
//            searchVC.bind(to: searchViewModel)
            
            //CollectionsViewController
//            var collectionsVC = CollectionsViewController()
//            let collectionViewModel = CollectionsViewModel()
//            let rootCollectionVC = PaprNavigationController(rootViewController: collectionsVC)
//            collectionsVC.bind(to: collectionViewModel)
            
            rootTradersVC.tabBarItem = UITabBarItem(
                title: "Traders",
                image: UIImage(named: "traders-white"),
                tag: 0
            )
            
//            rootCollectionVC.tabBarItem = UITabBarItem(
//                title: "Collections",
//                image: UIImage(named: "collections-white"),
//                tag: 1
//            )
//
//            rootSearchVC.tabBarItem = UITabBarItem(
//                title: "Search",
//                image: UIImage(named: "search-white"),
//                tag: 2
//            )
//
            followTabBarController.viewControllers = [
                rootTradersVC,
//                rootCollectionVC,
//                rootSearchVC
            ]
            
            return .tabBar(followTabBarController)
        case let .login(viewModel):
            var vc = LoginViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .alert(viewModel):
            var vc = AlertViewController(title: nil, message: nil, preferredStyle: .alert)
            vc.bind(to: viewModel)
            return .alert(vc)
        case let .activity(items):
            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            return .alert(vc)
//        case let .photoDetails(viewModel):
//            var vc = PhotoDetailsViewController.initFromNib()
//            vc.bind(to: viewModel)
//            return .present(vc)
//        case let .addToCollection(viewModel):
//            var vc = AddToCollectionViewController.initFromNib()
//            let rootViewController = UINavigationController(rootViewController: vc)
//            vc.bind(to: viewModel)
//            return .present(rootViewController)
//        case let .createCollection(viewModel):
//            var vc = CreateCollectionViewController.initFromNib()
//            let rootViewController = UINavigationController(rootViewController: vc)
//            vc.bind(to: viewModel)
//            return .present(rootViewController)
//        case let .searchPhotos(viewModel):
//            var vc = SearchPhotosViewController(collectionViewLayout: PinterestLayout(numberOfColumns: 2))
//            vc.bind(to: viewModel)
//            return .push(vc)
//        case let .searchCollections(viewModel):
//            var vc = SearchCollectionsViewController.initFromNib()
//            vc.bind(to: viewModel)
//            return .push(vc)
//        case let .searchUsers(viewModel):
//            var vc = SearchUsersViewController()
//            vc.bind(to: viewModel)
//            return .push(vc)
        case let .userProfile(viewModel):
            var vc = UserProfileViewController.initFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        }
    }
}
