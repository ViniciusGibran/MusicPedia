//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

class TagCell: UICollectionViewCell {
    let titleLabel = UILabel()
    var didSetupConstraints = false
    static var font: UIFont = UIFont.boldSystemFont(ofSize: 16)
    
    func bind(_ string: String, backgroundColor: UIColor, textColor: UIColor) {
        self.titleLabel.text = string
        self.accessibilityIdentifier = string
        self.titleLabel.textColor = textColor
        self.backgroundColor = backgroundColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.font = TagCell.font
        self.titleLabel.textAlignment = .center
        self.layer.cornerRadius = 6.0
        self.setupConstraints()
        self.layoutIfNeeded()
    }
    
    func setupConstraints() {
        if !didSetupConstraints {
            didSetupConstraints = true
            
            self.addSubview(titleLabel)
            self.titleLabel.pinEdgesToSuperview()
        }
    }
    
}

