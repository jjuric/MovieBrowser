//
//  FeedViewModel.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedViewModel {
    private var movieService: MovieService!
    var onSuccess: ((Movies) -> ())?
    var onFail: (()-> ())?
    
    init() {
        movieService = MovieService()
        movieService.requestTrendingMovies { [weak self] response in
            switch response {
            case .success(let movies):
                self?.onSuccess?(movies)
            case .fail:
                self?.onFail?()
            }
        }
    }
}
