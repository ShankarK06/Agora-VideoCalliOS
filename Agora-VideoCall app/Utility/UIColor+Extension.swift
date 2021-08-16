//
//  UIColor+Extension.swift
//  Agora-VideoCall app
//
//  Created by Shankar K on 16/08/21.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x0000_00FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


extension CAGradientLayer {
    
    static func customGradient(leftColor : UIColor, rightColor: UIColor) -> CAGradientLayer {
        
        let grandientColors : [CGColor] = [leftColor.cgColor, rightColor.cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = grandientColors
        gradientLayer.startPoint = CGPoint(x:0.0,y: 0.1)
        gradientLayer.endPoint = CGPoint(x:1.0,y: 1)
        
        
        return gradientLayer
    }
        
    
    
}
