//
//  Alignment.swift
//  Alignment
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/**
 Alignment is for defining where in the Depiction elements will show. Supported values are `left`, `right` and `center`
       
 - Author: Amy

 - Version: 1.0
 
 */
final public class Alignment {
    
    private enum Error: LocalizedError {
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
    internal class func alignment(for input: String) throws -> NSTextAlignment {
        switch input {
        case "left": return .left
        case "right": return .right
        case "center": return .center
        default: throw Error.invalid_alignment(input: input)
        }
    }
    
}
