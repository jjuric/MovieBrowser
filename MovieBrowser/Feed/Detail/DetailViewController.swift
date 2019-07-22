//
//  DetailViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 12/03/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: BaseViewController {
    
    var viewModel: DetailViewModel!
    private var movieFavorites = [Results]()
    
    private lazy var moviePoster: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var moviePlot: UILabel = {
        let plot = UILabel()
        plot.translatesAutoresizingMaskIntoConstraints = false
        plot.textAlignment = .center
        plot.font = .systemFont(ofSize: 18)
        plot.numberOfLines = 0
        return plot
    }()
    private lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .boldSystemFont(ofSize: 25)
        title.numberOfLines = 2
        title.textAlignment = .center
        return title
    }()
    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavorites))
        return button
    }()
    
    @objc func addToFavorites() {
        viewModel.saveFavorites()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = favoriteButton
        movieTitle.text = viewModel.movieTitle
        moviePlot.text = viewModel.moviePlot
        moviePoster.image = viewModel.moviePoster
        setConstraints()
        view.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.onCantSaveFavorite = { [weak self] in
            self?.showAlert(title: "Oops..", message: "You already saved that movie.")
        }
        viewModel.onSavedFavorite = { [weak self] in
            self?.showAlert(title: "Success!", message: "Movie saved to favorites.")
        }
        viewModel.onNotLoggedIn = { [weak self] in
            self?.showAlert(title: "Hey!", message: "You need to be logged in to add movies to favorites.")
        }
    }
    
    func setConstraints() {
        view.addSubview(movieTitle)
        view.addSubview(moviePlot)
        view.addSubview(moviePoster)
        
        movieTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        
        moviePlot.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 15).isActive = true
        moviePlot.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        moviePlot.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
        moviePlot.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
        
        moviePoster.heightAnchor.constraint(equalToConstant: view.bounds.size.height/3).isActive = true
        moviePoster.widthAnchor.constraint(equalToConstant: view.bounds.size.width/2).isActive = true
        moviePoster.topAnchor.constraint(equalTo: moviePlot.bottomAnchor, constant: 25).isActive = true
        moviePoster.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
