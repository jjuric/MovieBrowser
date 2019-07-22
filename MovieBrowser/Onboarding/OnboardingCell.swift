//
//  OnboardingCell.swift
//  MovieBrowser
//
//  Created by Jakov Juric on 14/07/2019.
//  Copyright © 2019 Jakov Juric. All rights reserved.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    
    lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 25)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        self.contentView.backgroundColor = .white
        addConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    
    private func addConstraints() {
        contentView.addSubview(title)
        
        title.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
