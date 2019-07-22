//
//  MainCoordinator.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    //private var viewControler: UIViewController!
    private var childCoordinators: [Coordinator] = [
        FeedCoordinator(),
        FavoritesCoordinator(),
        ProfileCoordinator()
    ]
    private var tabController: UITabBarController!
    //MARK: - Onboarding
    private var didShowTutorial: Bool = false
    
    func start() -> UIViewController {
        UserDefaults.standard.set(false, forKey: "firstLaunch")
        didShowTutorial = UserDefaults.standard.bool(forKey: "firstLaunch")
        if !didShowTutorial {
            return showTutorial()
        } else {
            return createTabBarController()
        }
    }
    
    private func showTab() {
        guard let window = UIApplication.shared.windows.first else { return }
        window.rootViewController = createTabBarController()
        window.makeKeyAndVisible()
    }
    
    private func createTabBarController() -> UIViewController {
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
            return UITabBarItem(title: "Explore", image: UIImage(named: "search"), tag: 1)
        case is FavoritesCoordinator:
            return UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        case is ProfileCoordinator:
            return UITabBarItem(title: "Profile", image: UIImage(named: "user_male"), tag: 3)
        default:
            return UITabBarItem(tabBarSystemItem: .more, tag: 0)
        }
    }
    //MARK: - Onboarding
    private func showTutorial() -> UIViewController{
        let tutorialVC = OnboardingViewController()
        let tutorialVM = OnboardingViewModel()
        
        tutorialVC.viewModel = tutorialVM
        
        tutorialVM.onClose = { [weak self] in
            self?.showTab()
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        
        return tutorialVC
    }
// OLD ONBOARDING USING PAGE CONTROLLER
//    private func showTutorial() -> UIViewController {
//        let tutorialVC = TutorialViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        let tutorialVM = TutorialViewModel()
//        let firstVC = FirstViewController()
//        let secondVC = SecondViewController()
//
//        tutorialVC.viewModel = tutorialVM
//        tutorialVC.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//
//        tutorialVM.onGotPreviousVC = { currentVC in
//            if String(describing: type(of: currentVC)) == "FirstViewController" {
//                return secondVC
//            } else {
//                return firstVC
//            }
//        }
//        tutorialVM.onGotNextVC = { currentVC in
//            if String(describing: type(of: currentVC)) == "FirstViewController" {
//                return secondVC
//            } else {
//                return firstVC
//            }
//        }
//        tutorialVM.onClose = { [weak self] in
//            self?.showTab()
//            UserDefaults.standard.set(true, forKey: "firstLaunch")
//        }
//        tutorialVM.onSwipe = { currentVC in
//            if String(describing: type(of: currentVC)) == "FirstViewController" {
//                return 1
//            } else {
//                return 0
//            }
//        }
//        return tutorialVC
//    }
}
