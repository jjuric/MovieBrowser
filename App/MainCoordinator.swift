//
//  MainCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    private var childCoordinators: [Coordinator] = [
        FeedCoordinator(),
        FavoritesCoordinator(),
        ProfileCoordinator()
    ]
    private var tabController: UITabBarController!
    
    func start() -> UIViewController {
        return createTabBarController()
    }
    
    func createTabBarController() -> UIViewController {
        tabController = UITabBarController()
        let viewControllers = childCoordinators.map { coordinator -> UIViewController in
            let vc = coordinator.start()
            vc.tabBarItem = tabbarItem(for: coordinator)
            return vc
        }
        tabController?.viewControllers = viewControllers
        return tabController
    }
    
    private func tabbarItem(for coordinator: Coordinator) -> UITabBarItem {
        switch coordinator {
        case is FeedCoordinator:
            return UITabBarItem(tabBarSystemItem: .search, tag: 1)
        case is FavoritesCoordinator:
            return UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        case is ProfileCoordinator:
            return UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
        default:
            return UITabBarItem(tabBarSystemItem: .more, tag: 0)
        }
    }
}
