//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import Foundation
import UIKit

class StartView: UIView, StateSubviewProtocol {
    
    private var didSetupViews: Bool = false
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Music Pedia\nFind your loved songs! ❤️🎶"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
        self.accessibilityIdentifier = "start_view"
    }
    
    func show() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0.0
        }
    }
    
    private func setupViews() {
        if !didSetupViews {
            self.didSetupViews = true
            self.setupConstraints()
        }
    }
    
    private func setupConstraints() {
        self.addSubview(infoLabel)
        self.infoLabel.pinBottom(60)
        self.infoLabel.centerHorizontally()
    }
    
}
