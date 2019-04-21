//
//  Scene.swift
//  Follow
//
//  Created by Anton on 19/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit

protocol TargetScene {
    var transition: SceneTransitionType { get }
}

enum Scene {
    case follow
    case createWallet(CreateWalletViewModel)
    case editProfile(EditProfileViewModel)
    case login(LoginViewModel)
    case transaction(TransactionViewModel)
    case userProfile(UserProfileViewModel)
    case alert(AlertViewModel)
    case activity([Any])
}

extension Scene: TargetScene {
    var transition: SceneTransitionType {
        switch self {
        case .follow:
            let followTabBarController = FollowTabBarController()
            
            //TradersViewController
            var tradersListVC = TradersListViewController.initFromNib()
            let tradersListViewModel = TradersListViewModel()
            let rootTradersListVC = FollowNavigationController(rootViewController: tradersListVC)
            tradersListVC.bind(to: tradersViewModel)
            
            //UserProfileViewController
            var userProfileVC = UserProfileViewController.initFromNib()
            let userProfileViewModel = UserProfileViewModel()
            let rootUserProfileVC = FollowNavigationController(rootViewController: userProfileVC)
            userProfileVC.bind(to: userProfileViewModel)
            
            rootTradersListVC.tabBarItem = UITabBarItem(
                title: "Traders List",
                image: UIImage(named: "traders-list-white"),
                tag: 0
            )
            
            rootUserProfileVC.tabBarItem = UITabBarItem(
                title: "User Profile",
                image: UIImage(named: "user-profile-white"),
                tag: 1
            )

            followTabBarController.viewControllers = [
                rootTradersListVC,
                rootUserProfileVC
            ]
            
            return .tabBar(followTabBarController)
        case let .createWallet(viewModel):
            var vc = CreateWalletViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .editProfile(viewModel):
            var vc = EditProfileViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .login(viewModel):
            var vc = LoginViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .transaction(viewModel):
            var vc = TransactionViewController.initFromNib()
            vc.bind(to: viewModel)
            return .present(vc)
        case let .userProfile(viewModel):
            var vc = UserProfileViewController.initFromNib()
            vc.bind(to: viewModel)
            return .push(vc)
        case let .alert(viewModel):
            var vc = AlertViewController(title: nil, message: nil, preferredStyle: .alert)
            vc.bind(to: viewModel)
            return .alert(vc)
        case let .activity(items):
            let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            return .alert(vc)
        }
    }
}
