//
//  UIColor+Extensions.swift
//  DepictionKit
//
//  Created by Amy While on 27/11/2022.
//

import UIKit

extension UIColor {
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        var hex = hex
        if hex.first == "#" {
            hex.removeFirst()
        }
        if hex.count == 6 {
            hex += "ff"
        }
        guard hex.count == 8 else { return nil }
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
            
            self.init(red: r, green: g, blue: b, alpha: a)
        } else {
            return nil
        }
    }
    
    public var hex: String {
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        var alpha = CGFloat(0)
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        red *= 255
        green *= 255
        blue *= 255
        alpha *= 255
        return String(format: "%02X%02X%02X%02X", red, green, blue, alpha)
    }
    
    var cssString: String {
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        var alpha = CGFloat(0)
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        red *= 255
        green *= 255
        blue *= 255
        return String(format: "rgba(%.0f, %.0f, %.0f, %.2f)", red, green, blue, alpha)
    }
    
}

