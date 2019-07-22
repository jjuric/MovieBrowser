//
//  FeedMovieCell.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 03/03/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedMovieCell: UITableViewCell {
    var movie: Results! {
        didSet {
            guard let movie = movie else { return }
            movieTitle.text = movie.title
            movieDescription.text = movie.overview
            guard let poster = movie.moviePoster else { return }
            moviePoster.image = poster
        }
    }
    
    lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .black
        title.textAlignment = .left
        title.font = .boldSystemFont(ofSize: 15)
        return title
    }()
    
    lazy var movieDescription: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.textColor = .black
        description.textAlignment = .left
        description.font = .systemFont(ofSize: 10)
        description.numberOfLines = 2
        description.sizeToFit()
        return description
    }()
    
    lazy var moviePoster: UIImageView = {
        let poster = UIImageView(image: nil)
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleAspectFill
        poster.layer.cornerRadius = 12
        poster.clipsToBounds = true
        return poster
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(movieTitle)
        contentView.addSubview(movieDescription)
        contentView.addSubview(moviePoster)
        
        movieTitle.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        movieTitle.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        movieTitle.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        movieTitle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        movieDescription.topAnchor.constraint(equalTo: movieTitle.bottomAnchor).isActive = true
        movieDescription.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        movieDescription.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -100).isActive = true
        
        moviePoster.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        moviePoster.heightAnchor.constraint(equalToConstant: 50).isActive = true
        moviePoster.widthAnchor.constraint(equalToConstant: 50).isActive = true
        moviePoster.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
