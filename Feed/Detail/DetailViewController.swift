//
//  DetailViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 12/03/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie: Results! {
        didSet {
            moviePoster.image = movie.moviePoster
            movieTitle.text = movie.title
            moviePlot.text = movie.overview
        }
    }
    private lazy var moviePoster: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var moviePlot: UILabel = {
        let plot = UILabel()
        plot.translatesAutoresizingMaskIntoConstraints = false
        plot.textAlignment = .left
        plot.font = .systemFont(ofSize: 12)
        plot.numberOfLines = 0
        return plot
    }()
    private lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 20)
        title.textAlignment = .center
        title.sizeToFit()
        return title
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }
    
    func setConstraints() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(movieTitle)
        view.addSubview(moviePlot)
        view.addSubview(moviePoster)
        
        movieTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movieTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        
        moviePlot.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 5).isActive = true
        moviePlot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5).isActive = true
        
        moviePoster.heightAnchor.constraint(equalToConstant: 100).isActive = true
        moviePoster.widthAnchor.constraint(equalToConstant: 50).isActive = true
        moviePoster.leadingAnchor.constraint(equalTo: moviePlot.trailingAnchor, constant: 5).isActive = true
        moviePoster.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5).isActive = true
    }
}
