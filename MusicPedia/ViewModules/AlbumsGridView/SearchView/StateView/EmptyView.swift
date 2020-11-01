//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import Foundation
import UIKit

class EmptyView: UIView, StateSubviewProtocol {
    
    private var didSetupViews: Bool = false
    
    let notFoundlabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Oops! Can't find anything for this search :(\n\n"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
        self.accessibilityIdentifier = "empty_view"
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
        self.addSubview(notFoundlabel)
        self.notFoundlabel.pinLeft(32)
        self.notFoundlabel.pinRight(32)
        self.notFoundlabel.centerToSuperView()
    }
    
}
