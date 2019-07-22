//
//  TutorialViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 11/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class TutorialViewController: UIPageViewController {
    //MARK: - Properties
    var viewModel: TutorialViewModel!
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Skip", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(closeTutorial), for: .touchUpInside)
        return btn
    }()
    private lazy var pageControl: UIPageControl = {
       let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.numberOfPages = 2
        control.currentPage = 0
        control.tintColor = .black
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)

        dataSource = self
        delegate = self
        
        setConstraints(for: closeBtn)
        setPageControl(for: pageControl)
    }
    //MARK: - Constraint setup
    func setConstraints(for btn: UIButton) {
        view.addSubview(btn)
        
        btn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        btn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    func setPageControl(for control: UIPageControl) {
        view.addSubview(control)
        control.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        control.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        control.heightAnchor.constraint(equalToConstant: 50).isActive = true
        control.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    //MARK: - Button action
    @objc func closeTutorial() {
        viewModel.closeTutorial()
    }
}

//MARK: _ UIPageViewContoller delegate setup
extension TutorialViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewModel.getPreviousVC(for: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewModel.getNextVC(for: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let previous = previousViewControllers.first {
                pageControl.currentPage = viewModel.swipe(for: previous)!
            }
        }
    }
    
}

