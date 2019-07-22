//
//  FavoritesViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {

    private var favoriteMovies: [Results] = []
    private var selectionFlag = false
    private var selectedItems: [IndexPath] = []
    var viewModel: FavoritesViewModel!
    
    private lazy var longGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress))
        
        return gesture
    }()
    
    private lazy var offlineView: UIView = {
        let view = OfflineView(for: self.view)
        view.onRetry = { [weak self] in
            self?.loadFavorites()
        }
        return view
    }()
    private lazy var collectionView: UICollectionView = {
       let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavoriteCell")
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
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
        
        collectionView.addGestureRecognizer(longGesture)
        
        title = "My Favorites"
        addCallBacks()
        loadFavorites()
        setupCollectionView(for: collectionView)
        setOfflineViewConstraints(for: offlineView)
        offlineView.isHidden = true
        
        //Navigation + delete
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteItemsTapped))
    }
    override func viewWillAppear(_ animated: Bool) {
        loadFavorites()
        addCallBacks()
    }
    
    @objc func didLongPress(_ gesture: UIGestureRecognizer) {
        switch(gesture.state)
        {
        case .began:
            guard let selectedIndex = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: selectedIndex)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
            collectionView.reloadData()
//            saveCurrentFavorites(favoriteMovies)
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func addCallBacks() {
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .initial:
                break
            case .loading:
                self?.offlineView.isHidden = true
                self?.spinner.startAnimating()
            case .loaded(let favorites):
                self?.offlineView.isHidden = true
                self?.collectionView.isHidden = false
                self?.spinner.stopAnimating()
                self?.favoriteMovies = favorites
                self?.collectionView.reloadData()
            case .decodeErr:
                self?.offlineView.isHidden = false
                self?.collectionView.isHidden = true
                self?.spinner.stopAnimating()
                self?.showAlert(title: "Oops...", message: "There was an error getting your favorites. Try again later.")
            case .noInternet:
                self?.offlineView.isHidden = false
                self?.collectionView.isHidden = true
                self?.spinner.stopAnimating()
            case .blank:
                self?.offlineView.isHidden = true
                self?.collectionView.isHidden = true
                self?.spinner.stopAnimating()
                self?.showAlert(title: "Oops...", message: "Your list seems to be empty. You can add movies from the Explore tab.")
                self?.collectionView.reloadData()
            case .noLogIn:
                self?.offlineView.isHidden = true
                self?.collectionView.isHidden = true
                self?.spinner.stopAnimating()
                self?.showAlert(title: "Hey!", message: "You need to be logged in to view your favorites!")
            }
        }
    }
    private func loadFavorites() {
        viewModel.getFavorites()
    }
    //MARK: - Navigation setup + deleteing items
    @objc func deleteItemsTapped() {
        setNavigationItems()
    }
    @objc func cancelTapped() {
        resetNavigationItems()
    }
    @objc func deleteSelectedItems() {
        deleteSelection()
    }
    func resetNavigationItems() {
        collectionView.allowsMultipleSelection = false
        selectionFlag = false
        for index in selectedItems {
            collectionView.deselectItem(at: index, animated: false)
        }
        selectedItems.removeAll()
        navigationItem.rightBarButtonItem?.title = "Select"
        navigationItem.rightBarButtonItem?.action = #selector(deleteItemsTapped)
        navigationItem.leftBarButtonItem = nil
    }
    func setNavigationItems() {
        collectionView.allowsMultipleSelection = true
        selectionFlag = true
        navigationItem.rightBarButtonItem?.title = "Cancel"
        navigationItem.rightBarButtonItem?.action = #selector(cancelTapped)
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedItems))
    }
    func deleteSelection() {
        collectionView.performBatchUpdates({
            selectedItems.sort(by: { $0 > $1})
            for index in selectedItems {
                favoriteMovies.remove(at: index.row)
            }
            collectionView.deleteItems(at: selectedItems)
            selectedItems.removeAll()
        }, completion: { [weak self] (true) in
            self?.resetNavigationItems()
            self?.saveCurrentFavorites(self!.favoriteMovies)
        })
    }
    func saveCurrentFavorites(_ movies: [Results]) {
        viewModel.deleteFavorites(movies)
        viewModel.saveFavorites(movies)
    }
    //MARK: - Collection,  view constraints, helper
    func setupCollectionView(for collection: UICollectionView) {
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
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
//MARK: - CollectionView delegate
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.movie = favoriteMovies[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectionFlag {
            if !(selectedItems.contains(indexPath)){
                selectedItems.append(indexPath)
            }
        } else {
            viewModel?.showDetails(for: favoriteMovies[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedItems.removeAll(where: { $0 == indexPath })
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmp = favoriteMovies[sourceIndexPath.item]
        favoriteMovies[sourceIndexPath.item] = favoriteMovies[destinationIndexPath.item]
        favoriteMovies[destinationIndexPath.item] = tmp
        for (index, _) in favoriteMovies.enumerated() {
            favoriteMovies[index].orderNumber = index
        }
        collectionView.reloadData()
    }
    
}
//MARK: - CollectionView Layout setup
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
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
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
