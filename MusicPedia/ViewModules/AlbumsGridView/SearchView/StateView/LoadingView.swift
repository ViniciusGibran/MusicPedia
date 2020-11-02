//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import Foundation
import UIKit

class LoadingView: UIView, StateSubviewProtocol {
    
    private var didSetupViews: Bool = false
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.alpha = 0.8
        indicator.startAnimating()
        return indicator
    }()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .white
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
    }
    
    func show() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1.0
            }
            self.activityIndicator.isHidden = false
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0.0
            }
            self.activityIndicator.isHidden = true
        }
    }
    
    private func setupViews() {
        if !didSetupViews {
            self.didSetupViews = true
            self.setupConstraints()
        }
    }
    
    private func setupConstraints() {
        self.addSubview(activityIndicator)
        self.activityIndicator.centerToSuperView()
        
        self.addSubview(loadingLabel)
        self.loadingLabel.pinBottom(60)
        self.loadingLabel.centerHorizontally()
    }
}
