//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import Foundation
import UIKit

class ToastView: UIView {
    
    var bottomConstraint: NSLayoutConstraint?
    
    let height: CGFloat = 50
    var duration: Double = 2
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    func show(_ text: String, duration: Double) {
        self.duration = duration
        self.infoLabel.text = text
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            window.addSubview(self)
            self.setupViews()
        }
    }
    
    func setupViews() {
        self.setupConstraints()
        self.animateShow()
        self.accessibilityIdentifier = "toast_view"
    }
    
    func animateShow() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.bottomConstraint?.constant = 0
            self.window?.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: self.duration, options: .curveEaseOut, animations: {
            self.bottomConstraint?.constant = self.height
            self.window?.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setupConstraints() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.addSubview(infoLabel)
        self.infoLabel.centerToSuperView()
        
        self.bottomConstraint = self.pinBottom(-self.height)
        self.pinLeft()
        self.pinRight()
        self.constraintHeight(self.height)
        
        self.window?.layoutIfNeeded()
        self.layoutIfNeeded()
    }
    
}

extension ToastView {
    class func show(_ text: String, duration: Double = 4) {
        let toast = ToastView()
        toast.show(text, duration: duration)
    }
}
