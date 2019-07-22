//
//  FavoriteCell.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 28/03/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    var movie: Results! {
        didSet {
            moviePoster.image = movie.moviePoster
            movieTitle.text = movie.title
        }
    }
    //MARK: - Collection Cell views
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
    private lazy var moviePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var movieTitle: UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 2
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        title.sizeToFit()
        title.lineBreakMode = .byWordWrapping
        return title
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                contentView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
            } else {
                contentView.backgroundColor = .clear
            }
        }
    }
    //MARK: - Collection Cell constraints
    func addViews() {
//        addSubview(moviePoster)
        addSubview(movieTitle)
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

        
        movieTitle.topAnchor.constraint(equalTo: moviePoster.bottomAnchor, constant: 6).isActive = true
        movieTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        movieTitle.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}
