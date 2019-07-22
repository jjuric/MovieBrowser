//
//  FeedMovieCell.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 03/03/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedMovieCell: UICollectionViewCell {
    var movie: Results! {
        didSet {
            guard let movie = movie else { return }
            guard let poster = movie.moviePoster else { return }
            movieTitle.text = movie.title
            moviePoster.image = poster
        }
    }
    
    // MARK: - Views for collection cell
    lazy var movieTitle: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        title.font = .boldSystemFont(ofSize: 15)
        title.numberOfLines = 1
        title.lineBreakMode = .byTruncatingTail
        return title
    }()
    lazy var posterContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.8
        container.layer.shadowOffset = CGSize(width: 10, height: 10)
        container.layer.shadowRadius = 10
//        container.layer.shadowPath = UIBezierPath(roundedRect: container.bounds, cornerRadius: 10).cgPath
        return container
    }()
    lazy var moviePoster: UIImageView = {
        let poster = UIImageView(image: nil)
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleAspectFill
        poster.layer.cornerRadius = 10
        poster.clipsToBounds = true
        return poster
    }()
    
    // MARK: - Collection cell init
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        setupCollectionCell()
    }
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    
    // MARK: View helper function
    func setupCollectionCell() {
        contentView.addSubview(movieTitle)
//        contentView.addSubview(moviePoster)
        contentView.addSubview(posterContainer)
        posterContainer.addSubview(moviePoster)
        
        posterContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        posterContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        posterContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        posterContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        moviePoster.topAnchor.constraint(equalTo: posterContainer.topAnchor).isActive = true
        moviePoster.centerXAnchor.constraint(equalTo: posterContainer.centerXAnchor).isActive = true
        moviePoster.heightAnchor.constraint(equalTo: posterContainer.heightAnchor).isActive = true
        moviePoster.widthAnchor.constraint(equalTo: posterContainer.widthAnchor).isActive = true
        
        movieTitle.topAnchor.constraint(equalTo: posterContainer.bottomAnchor, constant: 5).isActive = true
        movieTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        movieTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        movieTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }
   
    
}
