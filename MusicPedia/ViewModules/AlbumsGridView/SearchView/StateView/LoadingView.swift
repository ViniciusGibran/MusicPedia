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
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
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
            self.startLoadingAnimation()
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0.0
            }
            self.activityIndicator.isHidden = true
            self.stopLoadingAnimation()
        }
    }
    
    private func setupViews() {
        if !didSetupViews {
            self.didSetupViews = true
            self.setupConstraints()
        }
    }
    
    weak var timer: Timer?
    
    private func setupConstraints() {
        self.addSubview(activityIndicator)
        self.activityIndicator.centerToSuperView()
        
        self.addSubview(loadingLabel)
        self.loadingLabel.centerHorizontally()
        self.loadingLabel.pinBottom(140)
    }
    
    private func startLoadingAnimation() {
        self.loadingLabel.text = ""
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            self.loadingLabel.text?.append(".")
            
            if self.loadingLabel.text == "....." {
                self.loadingLabel.text = ""
            }
        }
    }
    
    private func stopLoadingAnimation() {
        timer?.invalidate()
        timer = nil
    }
    
}
