//
//  FontWeight.swift
//  FontWeight
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/**
 The weight for fonts to use in text based views. This matches the system font.
 
 Supports values are:
 * ultralight
 * thin
 * light
 * regular
 * medium
 * semibold
 * bold
 * heavy
 * black
       
 - Author: Amy

 - Version: 1.0
 
 */
final public class FontWeight {
    
    enum Error: LocalizedError {
        case invalid_weight(input: String)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_weight(input): return "Font Weight `\(input)` is invalid"
            }
        }
    }
    
    /// - Throws: Error of type `Color.Error`
    /// - Parameters:
    ///     - input: `input` should be a string that matches an iOS system font
    internal class func weight(for input: String) throws -> UIFont.Weight {
        switch input {
        case "ultralight": return .ultraLight
        case "thin": return .thin
        case "light": return .light
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: throw FontWeight.Error.invalid_weight(input: input)
        }
    }
    
}
