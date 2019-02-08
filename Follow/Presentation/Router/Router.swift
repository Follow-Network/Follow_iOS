//
//  Router.swift
//  Follow
//
//  Created by Anton Grigorev on 05/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class Router: NSObject {
    
    // MARK: - Enum
    
    enum TabBarRootItem: Int {
        case traders = 0
        case chats = 1
        case profile = 2
    }
    
    // MARK: - Properties
    
    private let followAPI: FollowAPI
    lazy fileprivate var tabBarController = self.setupTabBarController()
    
    // MARK: - Initializer
    
    init(followAPI: FollowAPI) {
        self.followAPI = followAPI
    }
    
    // MARK: - Setup navigation
    
    private func setupTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            TradersViewController(viewModel: TradersViewModel(followAPI: followAPI), router: self),
            ChatsViewController(viewModel: ChatsViewModel(followAPI: followAPI), router: self),
            ProfileViewController(router: self)
            ].map { UINavigationController(rootViewController: $0) }
        tabBarController.tabBar.tintColor = UIColor(commonColor: .yellow)
        return tabBarController
    }
    
    func setup(`for` delegate: AppDelegate, with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        followAPI.start(with: launchOptions)
        delegate.window = {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .white
            window.rootViewController = tabBarController
            return window
        }()
    }
    
    func tabBarItem(`for` rootItem: TabBarRootItem) -> UITabBarItem {
        switch rootItem {
        case .traders: return UITabBarItem(title: "Traders", image: UIImage(named: "Traders_Icon"), tag: rootItem.rawValue)
        case .chats: return UITabBarItem(title: "Chats", image: UIImage(named: "Chats_Icon"), tag: rootItem.rawValue)
        case .profile: return UITabBarItem(title: "Profile", image: UIImage(named: "Profile_Icon"), tag: rootItem.rawValue)
        }
    }
    
    // MARK: - Routing functions
    
//    func showFilmDetails(`for` film: Film, from viewController: UIViewController) {
//        Analytics.track(viewContent: "Selected film", ofType: "Film", withId: "\(film.id)", withAttributes: ["Title": film.fullTitle])
//
//        let viewModel = FilmDetailsViewModel(withFilm: film, tmdbAPI: tmdbAPI)
//        let filmDetailsViewController = FilmDetailsViewController(viewModel: viewModel, router: self)
//
//        viewController.navigationController?.delegate = self
//        viewController.navigationController?.pushViewController(filmDetailsViewController, animated: true)
//    }
//
//    func showPerson(_ person: Person, backgroundImagePath path: Driver<ImagePath>, from viewController: UIViewController) {
//        Analytics.track(viewContent: "Selected person", ofType: "Person", withId: "\(person.id)", withAttributes: ["Person": person.name])
//
//        let viewModel = PersonViewModel(withPerson: person, tmdbAPI: tmdbAPI)
//        let personViewController = PersonViewController(viewModel: viewModel, backgroundImagePath: path, router: self)
//
//        viewController.navigationController?.delegate = self
//        viewController.navigationController?.pushViewController(personViewController, animated: true)
//    }
}

// MARK: -

extension Router: UINavigationControllerDelegate {
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        switch (operation, fromVC, toVC) {
//        case (.push, _, toVC) where toVC is FilmDetailsViewController:
//            guard let fromVC = fromVC as? (UIViewController & FilmDetailsTransitionable) else { return nil }
//            return ToFilmDetailsTransitionAnimator(from: fromVC, destinationView: toVC.view)
//        default: return nil
//        }
            return nil
    }
}
