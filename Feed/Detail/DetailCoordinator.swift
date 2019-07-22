//
//  DetailCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 12/03/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class DetailCoordinator: Coordinator {
    var navigation = UINavigationController()
    
    func start() -> UIViewController {
        return showDetails()
    }
    
    func showDetails() -> UIViewController {
        let detailVC = DetailViewController()
        navigation.setViewControllers([detailVC], animated: false)
        return navigation
    }
}
