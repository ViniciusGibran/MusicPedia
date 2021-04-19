//
//  UIColor+Utils.swift
//  Created by Vinicius Gibran on 01/07/19.
//

import UIKit

extension UIColor {
    
    @nonobjc class var slate: UIColor {
        return UIColor(red: 77, green: 96, blue: 112)
    }
    
    @nonobjc class var acqua: UIColor {
        return UIColor(red: 80, green: 227, blue: 194)
    }
    
    @nonobjc class var deepPurple: UIColor {
        return UIColor(red: 221, green: 5, blue: 14)
    }
    
    @nonobjc class var darkBlue: UIColor {
        return UIColor(red: 17, green: 34, blue: 55)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(Double(red) / 255.0),
                  green: CGFloat(Double(green) / 255.0),
                  blue: CGFloat(Double(blue) / 255.0),
                  alpha: 1)
    }    
}
