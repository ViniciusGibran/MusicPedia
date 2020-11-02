//
//  UITextFIeld+Utils.swift
//  Created by Vinicius Gibran on 01/07/19.
//

import UIKit

extension UITextField {
    func setPadding(_ width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
