//
//  FavoritesCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    private var navigationController = UINavigationController()
    
    func start() -> UIViewController {
        return showFavorites()
    }
    
    func showFavorites() -> UIViewController {
        let favoriteVC = FavoritesViewController()
        navigationController.setViewControllers([favoriteVC], animated: false)
        return navigationController
    }
}
