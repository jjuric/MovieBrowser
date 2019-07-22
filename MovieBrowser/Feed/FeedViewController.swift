//
//  FeedViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedViewController: BaseViewController {
    
    // MARK: - Properties
    var movieList: Movies!
    var viewModel: FeedViewModel!
    //MARK: - Views
    private lazy var offlineView: UIView = {
        let view = OfflineView(for: self.view)
        view.onRetry = { [weak self] in
            self?.loadData()
        }
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(FeedMovieCell.self, forCellWithReuseIdentifier: "FeedMovieCell")
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionConstraints(for: collectionView)
        setOfflineViewConstraints(for: offlineView)
        offlineView.isHidden = true
        addCallbacks()
        loadData()
    }
    // MARK: - CollectionView/View constraints setup
    private func setCollectionConstraints(for collection: UICollectionView) {
        view.addSubview(collection)
        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collection.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    private func setOfflineViewConstraints(for offView: UIView) {
        view.addSubview(offView)
        offView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        offView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        offView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        offView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        view.bringSubviewToFront(offView)
    }
    //MARK: - Callbacks for data fetching
    private func addCallbacks() {
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .initial:
                break
            case .loading:
                self?.offlineView.isHidden = true
                self?.spinner.startAnimating()
            case .noInternet:
                self?.offlineView.isHidden = false
                self?.spinner.stopAnimating()
            case .loaded(let movies):
                self?.offlineView.isHidden = true
                self?.spinner.stopAnimating()
                self?.movieList = movies
                self?.collectionView.reloadData()
            }
        }
    }
    private func loadData() {
        viewModel.loadData()
    }
}
// MARK: - CollectionView delegate setup
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedMovieCell", for: indexPath) as! FeedMovieCell
        cell.movie = movieList?.results[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetails(for: movieList.results[indexPath.row])
    }
}
// MARK: - Collection view and items sizing
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width/3) - 16, height: (collectionView.bounds.size.height/4) - 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
