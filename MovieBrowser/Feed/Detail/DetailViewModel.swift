//
//  DetailViewModel.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 09/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import Firebase

class DetailViewModel {
    
    private let movie: Results
    var onSavedFavorite: (()->())?
    var onCantSaveFavorite: (()->())?
    var onNotLoggedIn: (()->())?
    
    init(movie: Results) {
        self.movie = movie
    }
    
    var movieTitle: String {
        return movie.title
    }
    var moviePlot: String {
        return movie.overview
    }
    var moviePoster: UIImage? {
        return movie.moviePoster
    }
    
    //Firestore add movie to favorites under user ID
    func saveFavorites() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { onNotLoggedIn?(); return }
        db.collection(user.uid).document(movie.title).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                self?.onCantSaveFavorite?()
            } else {
                guard let welf = self else { return }
                db.collection(user.uid).document(welf.movie.title).setData([
                    "title": welf.movie.title,
                    "plot": welf.movie.overview,
                    "poster_path": welf.movie.poster_path,
                    "vote_average": welf.movie.vote_average
                ]) { err in
                    if let err = err {
                        print("Error while writing to collection \(err)")
                    } else {
                        print("Document added successfully")
                    }
                }
                self?.onSavedFavorite?()
            }
        }
    }
}
