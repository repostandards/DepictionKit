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
    init(for input: Any) throws {
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
            self.dark_mode = color
            return
        }
        throw Color.Error.invalid_color(input: input)
    }
    
}
