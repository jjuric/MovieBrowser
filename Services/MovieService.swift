//
//  NetworkService.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation
import Alamofire

class MovieService {
    
    private let apiKey = "768eba2cb085ac54a504be10a14f727c"
    private var movieID: String!
    
    //TODO: add function for specific movie
    
    func requestTrendingMovies(completionHandler: @escaping (MovieResponse<Movies>) -> ()) {
        Alamofire.request("https://api.themoviedb.org/3/trending/movie/week?api_key=\(apiKey)").responseJSON { response in
            guard let data = response.data else { completionHandler(.fail); return }
            let decoder = JSONDecoder()
            guard let movies = try? decoder.decode(Movies.self, from: data) else { completionHandler(.fail); return }
            completionHandler(.success(movies))
        }
    }
}
