//
//  FavoritesCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    private var navigationController = MainNavigationController()
    
    func start() -> UIViewController {
        return showFavorites()
    }
    
    func showFavorites() -> UIViewController {
        let favoritesVC = FavoritesViewController()
        let favoritesVM = FavoritesViewModel()
        favoritesVC.viewModel = favoritesVM
        
        favoritesVM.onShowDetails = { [weak self] movie in
            self?.showDetails(for: movie)
        }
        navigationController.setViewControllers([favoritesVC], animated: false)
        return navigationController
    }
    
    private func showDetails(for movie: Results) {
        let detailVC = DetailViewController()
        let detailVM = DetailViewModel(movie: movie)
        
        detailVC.viewModel = detailVM
        
        navigationController.pushViewController(detailVC, animated: true)
    }
}
