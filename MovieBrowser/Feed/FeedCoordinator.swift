//
//  FeedCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedCoordinator: Coordinator {
    
    private var navigationController = MainNavigationController()
    
    func start() -> UIViewController {
        return showFeed()
    }
    //MARK: - Feed setup
    private func showFeed() -> UIViewController {
        let feedVC = FeedViewController()
        let feedVM = FeedViewModel(movieService: MovieService())
        feedVC.viewModel = feedVM

        feedVM.onShowDetails = { [weak self] movie in
            self?.showDetails(for: movie)
        }
        
        navigationController.setViewControllers([feedVC], animated: false)
        return navigationController
    }
    //MARK: - Movie Detail screen setup
    private func showDetails(for movie: Results) {
        let detailVC = DetailViewController()
        let detailVM = DetailViewModel(movie: movie)
        
        detailVC.viewModel = detailVM
        
        navigationController.pushViewController(detailVC, animated: true)
    }
    
    
}
