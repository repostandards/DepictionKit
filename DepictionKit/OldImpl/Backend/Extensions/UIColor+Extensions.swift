//
//  UIColor+Extensions.swift
//  UIColor+Extensions
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

internal extension UIColor {
    
    static func color(from int: Int) -> UIColor? {
        let hex = String(format: "%06X", int)
        if hex.count == 6 {
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0
            let r, g, b: CGFloat
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                return UIColor(red: r, green: g, blue: b, alpha: 1)
            }
        }
        return nil
    }
    
    static func color(from hex: String) -> UIColor? {
        var hex = hex
        hex = hex.replacingOccurrences(of: "#", with: "")
        if hex.count == 6 {
            let r, g, b: CGFloat
            let scanner = Scanner(string: hex)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                return UIColor(red: r, green: g, blue: b, alpha: 1)
            }
        }
        return nil
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
