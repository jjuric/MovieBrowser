//
//  OnboardingViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 14/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

private var temp = ["1","2"]

class OnboardingViewController: UIViewController {

    var viewModel: OnboardingViewModel!
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        let flow = collection.collectionViewLayout as! UICollectionViewFlowLayout
        flow.scrollDirection = .horizontal
        return collection
    }()
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.numberOfPages = 2
        control.currentPage = 0
        control.tintColor = .black
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = .black
        control.addTarget(self, action: #selector(tapPageControl), for: .touchUpInside)
        return control
    }()
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.setTitle("Close", for: .normal)
        btn.addTarget(self, action: #selector(closeOnboarding), for: .touchUpInside)
        return btn
    }()
    private lazy var nextButton: UIButton = {
       let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        btn.layer.cornerRadius = 10
        btn.setTitle("Next", for: .normal)
        btn.titleLabel?.textColor = .black
        btn.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setConstraints()
    }

    private func setConstraints() {
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(closeBtn)
        closeBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        closeBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        closeBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closeBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(nextButton)
        nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -25).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func tapPageControl() {
        let pageWidth = collectionView.frame.size.width
        let desiredPage = CGPoint(x: pageWidth * CGFloat(integerLiteral: pageControl.currentPage), y: 0)
        collectionView.setContentOffset(desiredPage, animated: true)
        if pageControl.currentPage == 0 {
            nextButton.setTitle("Next", for: .normal)
        } else {
            nextButton.setTitle("Previous", for: .normal)
        }
    }
    
    @objc func closeOnboarding() {
        viewModel.closeOnboarding()
    }
    
    @objc func nextPage() {
        let offset = collectionView.contentOffset.x
        if offset == 0 {
            let pageWidth = collectionView.frame.size.width
            let desiredPage = CGPoint(x: pageWidth * CGFloat(integerLiteral: pageControl.currentPage + 1), y: 0)
            collectionView.setContentOffset(desiredPage, animated: true)
            nextButton.setTitle("Previous", for: .normal)
            pageControl.currentPage = 1
        } else {
            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            nextButton.setTitle("Next", for: .normal)
            pageControl.currentPage = 0
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        cell.title.text = temp[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        let pageNumber = collectionView.contentOffset.x / pageWidth
        pageControl.currentPage = Int(floor(pageNumber))
        if pageControl.currentPage == 0 {
            nextButton.setTitle("Next", for: .normal)
        } else {
            nextButton.setTitle("Previous", for: .normal)
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
}
