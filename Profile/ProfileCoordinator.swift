//
//  ProfileCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class ProfileCoordinator: Coordinator {
    
    private var navigationController = UINavigationController()
    
    func start() -> UIViewController {
        return showProfile()
    }
    
    func showProfile() -> UIViewController {
        let profileVC = ProfileViewController()
        navigationController.setViewControllers([profileVC], animated: false)
        return navigationController
    }
}
