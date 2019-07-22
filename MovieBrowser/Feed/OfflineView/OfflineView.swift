//
//  OfflineView.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 10/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class OfflineView: UIView {
    
    var onRetry: (() -> Void)?
    //MARK: - Properties/views
    lazy var offlineImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "networkError")
        return imgView
    }()
    lazy var offlineLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 15)
        lbl.text = "There seems to be a problem with your internet"
        return lbl
    }()
    lazy var retryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Retry", for: .normal)
        btn.addTarget(self, action: #selector(reloadFeed), for: .touchUpInside)
        return btn
    }()
    //MARK: - Init
    init(for view: UIView) {
        super.init(frame: view.frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARK: - Constraints setup
    func setupConstraints() {
        addSubview(offlineImageView)
        addSubview(offlineLabel)
        addSubview(retryButton)
        
        
        offlineImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        offlineImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100).isActive = true
        offlineImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        offlineImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        offlineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        offlineLabel.topAnchor.constraint(equalTo: offlineImageView.bottomAnchor, constant: 15).isActive = true
        
        retryButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        retryButton.topAnchor.constraint(equalTo: offlineLabel.bottomAnchor, constant: 15).isActive = true
        retryButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        retryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func reloadFeed() {
        onRetry?()
    }

}
