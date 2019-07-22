//
//  Movies.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import Foundation
import UIKit

class Movies: Codable {
    var results: [Results]
}
class Results: Codable {
    var title: String
    var overview: String
    var poster_path: String
    var vote_average: Double
    
    var moviePoster: UIImage? {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)") else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
//    private enum CodingKeys: String, CodingKey {
//        case title
//        case overview = "moviePlot"
//        case poster_path = "moviePoster"
//        case vote_average = "movieRating"
//    }
}
