//
//  Color.swift
//  Color
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/// Color object to define how an element should appear in light and dark mode
final public class Color {
    
    /// Color to display in light mode
    public let light_mode: UIColor
    /// Color to display in dark mode
    public let dark_mode: UIColor

    public func color(for theme: Theme) -> UIColor {
        return theme.dark_mode ? dark_mode : light_mode
    }
    
    enum Error: LocalizedError {
        case invalid_color(input: Any)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_color(input): return "Colour `\(input)` is invalid"
            }
        }
    }
    
    /// - Throws: Error of type `Color.Error`
    /// - Parameters:
    ///     - input: `input` can either be a `[String: String]` or `String` object.
    /// - Note: # is not required at the start of hex codes
    init(for input: Any, inferDarkColorIfNeeded: Bool = false) throws {
        if let dict = input as? [String: String],
           let _light_mode = dict["light_theme"],
           let _dark_theme = dict["dark_theme"],
           let light_mode = UIColor.color(from: _light_mode),
           let dark_mode = UIColor.color(from: _dark_theme) {
            self.light_mode = light_mode
            self.dark_mode = dark_mode
            return
        } else if let string = input as? String,
                  let color = UIColor.color(from: string) {
            self.light_mode = color
            self.dark_mode = inferDarkColorIfNeeded ? Self.inferDarkColor(for: color) : color
            return
        }
        throw Color.Error.invalid_color(input: input)
    }

    private static func inferDarkColor(for lightColor: UIColor) -> UIColor {
        // Borrowed from Cephei. Desaturates colors a little bit so they look “right” in dark mode.
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        lightColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: max(0.20, s * 0.96), brightness: b, alpha: a)
    }
    
}