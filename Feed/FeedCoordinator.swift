//
//  FeedCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedCoordinator: Coordinator {
    
    private var navigationController = UINavigationController()
    
    func start() -> UIViewController {
        return showFeed()
    }
    
    private func showFeed() -> UIViewController {
        let feedVC = FeedViewController()
        let feedVM = FeedViewModel()
        feedVC.viewModel = feedVM
        navigationController.setViewControllers([feedVC], animated: false)
        return navigationController
    }
    
}
