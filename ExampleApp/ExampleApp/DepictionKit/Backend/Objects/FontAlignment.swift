//
//  FontAlignment.swift
//  FontAlignment
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/// Class to generate font alignment
final public class FontAlignment {
    
    enum Error: LocalizedError {
        case invalid_alignment(input: String)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_alignment(input): return "Font Weight `\(input)` is invalid"
            }
        }
    }
    
    /// - Throws: Error of type `Color.Error`
    /// - Parameters:
    ///     - input: `input` should be a string that matches an iOS system font
    public class func alignment(for input: String) throws -> NSTextAlignment {
        switch input {
        case "left": return .left
        case "right": return .right
        case "center": return .center
        default: throw FontAlignment.Error.invalid_alignment(input: input)
        }
    }
    
}
