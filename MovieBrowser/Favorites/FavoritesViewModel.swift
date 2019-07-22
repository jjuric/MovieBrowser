//
//  FavoritesViewModel.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 09/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class FavoritesViewModel {
    
    private let db = Firestore.firestore()
    
    //MARK: - State setup
    enum State {
        case initial
        case loading
        case loaded([Results])
        case decodeErr
        case noInternet
        case blank
        case noLogIn
    }
    
    var onShowDetails: ((Results)->())?
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
    
    // Show movie details
    func showDetails(for movie: Results) {
        onShowDetails?(movie)
    }
    
    // Fetch, save & delete favorite movies from Firestore
    func getFavorites() {
        state = .loading
        if Auth.auth().currentUser == nil {
            state = .noLogIn
            onStateChanged?(state)
        }
        else if NetworkReachabilityManager()!.isReachable {
            guard let user = Auth.auth().currentUser else { print("Error, no user logged in, can't get Favorites"); return }
            
            db.collection(user.uid).getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("There was an error while getting user favorites: \(error)")
                    self?.state = .decodeErr
                } else {
                    if snapshot!.documents.isEmpty {
                        self?.state = .blank
                    } else {
                        var favorites: [Results] = []
                        for document in snapshot!.documents {
                            if !(document.reference.documentID == "UserInfo") {
                                guard let title = document.data()["title"] as? String else { return }
                                guard let overview = document.data()["plot"] as? String else { return }
                                guard let poster_path = document.data()["poster_path"] as? String else { return }
                                guard let vote_average = document.data()["vote_average"] as? Double else { return }
                                
                                let movie = Results(title: title, overview: overview, poster_path: poster_path, vote_average: vote_average)
                                favorites.append(movie)
                            }
                            
                        }
                        self?.state = .loaded(favorites)
                    }
                }
            }
        }
        else {
            state = .noInternet
            onStateChanged?(state)
        }
    }
    func saveFavorites(_ movies: [Results]) {
        guard let user = Auth.auth().currentUser else { print("Error, no user logged in, can't save to Favorites"); return }
        
        for movie in movies {
            db.collection(user.uid).document(movie.title).getDocument { [weak self] (document, error) in
                if let document = document, document.exists {
                    //DO NOTHING or CHANGE ORDER NUMBER
                    
                } else {
                    self?.db.collection(user.uid).document(movie.title).setData([
                        "title": movie.title,
                        "plot": movie.overview,
                        "poster_path": movie.poster_path,
                        "vote_average": movie.vote_average
                    ]) { err in
                        if let err = err {
                            print("Error while writing to collection \(err)")
                        } else {
                            print("Document added successfully")
                        }
                    }
                }
            }
        }
    }
    func deleteFavorites(_ movies: [Results]) {
        guard let user = Auth.auth().currentUser else { print("Error, no user logged in, can't edit Favorites"); return}
        
        db.collection(user.uid).getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error while fetching favorites for user: \(error)")
                self?.state = .decodeErr
            } else {
                for document in snapshot!.documents {
                    let title = document.data()["title"] as! String
                    if movies.contains(where: {$0.title==title}) {
                        //DO NOTHING -> DON'T DELETE
                    } else {
                        document.reference.delete()
                    }
                }
            }
        }
    }
}
