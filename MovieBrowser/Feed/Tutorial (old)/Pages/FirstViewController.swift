//
//  FirstViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 11/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    private lazy var welcomeMsg: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 45)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.text = "Explore new releases!"
        return lbl
    }()
    
    private lazy var feedExplanation: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.font = .systemFont(ofSize: 25)
        text.numberOfLines = 0
        text.text = "Feel free to explore new movie releases in the 'Explorer' tab, click on a movie you think looks interesting and dive deeper into its plot."
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupConstraints()
    }

    func setupConstraints() {
        view.addSubview(welcomeMsg)
        view.addSubview(feedExplanation)
        
        welcomeMsg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeMsg.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        welcomeMsg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        welcomeMsg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
        feedExplanation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        feedExplanation.topAnchor.constraint(equalTo: welcomeMsg.bottomAnchor, constant: 20).isActive = true
        feedExplanation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        feedExplanation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
    }
}
