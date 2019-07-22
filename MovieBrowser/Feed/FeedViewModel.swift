//
//  FeedViewModel.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedViewModel {
    //MARK: - Init with moview service
    private var movieService: MovieService
    
    init(movieService: MovieService) {
        self.movieService = movieService
    }

    var onShowDetails: ((Results) -> Void)?
    
    //MARK: - State setup
    enum State {
        case initial
        case loading
        case loaded(Movies)
        case noInternet
    }
    
    var onStateChanged: ((State)->Void)? {
        didSet {
            self.onStateChanged?(self.state)
        }
    }
    
    private var state: State = .initial {
        didSet {
            onStateChanged?(state)
        }
    }
    
    func loadData() {
        state = .loading
        movieService = MovieService()
        movieService.requestTrendingMovies { [weak self] response in
            switch response {
            case .success(let movies):
                self?.state = .loaded(movies)
            case .fail:
                self?.state = .noInternet
            }
        }
    }
    
    func showDetails(for movie: Results) {
       onShowDetails?(movie)
    }
    
}
