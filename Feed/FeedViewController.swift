//
//  FeedViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 20/02/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    var movieList: Movies!
    var viewModel: FeedViewModel! {
        didSet {
            viewModel.onSuccess = { [weak self] movies in
                self?.movieList = movies
                // FIXME: Move table reload to layout subviews?
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            viewModel.onFail = {
                print("Error while requesting movie feed")
            }
        }
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FeedMovieCell.self, forCellReuseIdentifier: "movieCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableConstraints(for: tableView)
    }
    
    func setTableConstraints(for table: UITableView) {
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! FeedMovieCell
        if let movies = movieList {
            cell.movie = movies.results[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.movie = movieList.results[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: false)
    }
}
