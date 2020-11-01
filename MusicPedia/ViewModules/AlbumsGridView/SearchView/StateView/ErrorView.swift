//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import Foundation
import UIKit

class ErrorView: UIView, StateSubviewProtocol {
    
    private var didSetupViews: Bool = false
    
    var errorMessage: String = "Error!" {
        didSet {
            self.errorLabel.text = "Error =( \n\n" + errorMessage
        }
    }
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Error!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
        self.accessibilityIdentifier = "error_view"
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
        self.addSubview(errorLabel)
        self.errorLabel.pinLeft(32)
        self.errorLabel.pinRight(32)
        self.errorLabel.centerToSuperView()
    }
    
}
