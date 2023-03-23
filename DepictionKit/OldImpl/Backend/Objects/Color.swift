//
//  Color.swift
//  Color
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/**
 Color type that takes a light and dark mode color option
 
 The values should be HEX codes, they do not require # at the start.
 
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - light_theme: `String`; Light mode color.
    - dark_theme: `String`; Dark mode color.
 */
final public class Color {
    
    /// Color to display in light mode
    internal let light_mode: UIColor
    /// Color to display in dark mode
    internal let dark_mode: UIColor

    internal func color(for theme: Theme) -> UIColor {
        theme.dark_mode ? dark_mode : light_mode
    }
    
    private enum Error: LocalizedError {
        case invalid_color(input: Any)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_color(input): return "Colour `\(input)` is invalid"
            }
        }
    }
    
    /// - Throws: Error of type `Color.Error`
    /// - Parameters:
    ///     - input: `input` has to be a `[String: String]`
    /// - Note: # is not required at the start of hex codes
    internal init(for input: Any, inferDarkColorIfNeeded: Bool = false) throws {
        if let dict = input as? [String: String],
           let _light_mode = dict["light_theme"],
           let _dark_theme = dict["dark_theme"],
           let light_mode = UIColor.color(from: _light_mode),
           let dark_mode = UIColor.color(from: _dark_theme) {
            self.light_mode = light_mode
            self.dark_mode = dark_mode
            return
        }
        throw Color.Error.invalid_color(input: input)
    }

    private class func inferDarkColor(for lightColor: UIColor) -> UIColor {
        // Borrowed from Cephei. Desaturates colors a little bit so they look “right” in dark mode.
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        lightColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: max(0.20, s * 0.96), brightness: b, alpha: a)
    }
    
}
