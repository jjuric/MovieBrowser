//
//  SecondViewController.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 11/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private lazy var profileMsg: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 45)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.text = "Log in using Google!"
        return lbl
    }()
    
    private lazy var profileExplanation: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .center
        text.font = .systemFont(ofSize: 25)
        text.numberOfLines = 0
        text.text = "Log in to your profile and save your favorite new releases. This way you can easily keep track of the movies you would like to watch and the movies you'd like to watch again."
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(profileMsg)
        view.addSubview(profileExplanation)
        
        profileMsg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileMsg.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        profileMsg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
        profileMsg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        
        profileExplanation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileExplanation.topAnchor.constraint(equalTo: profileMsg.bottomAnchor, constant: 20).isActive = true
        profileExplanation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
        profileExplanation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
    }

}
