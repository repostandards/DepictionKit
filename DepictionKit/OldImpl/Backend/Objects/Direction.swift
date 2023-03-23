//
//  Direction.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import Foundation

/**
 Direction for elements to align in. This should be a string and supports the values `horizontal` and `vertical`
       
 - Author: Amy

 - Version: 1.0
 
 */
public enum Direction {
    
    case horizontal
    case vertical
    
    init(input: String) throws {
        switch input {
        case "horizontal": self = .horizontal
        case "vertical": self = .vertical
        default: throw Direction.Error.invalid_alignment(input: input)
        }
    }
    
    private enum Error: LocalizedError {
        case invalid_alignment(input: String)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_alignment(input): return "Alignment`\(input)` is invalid"
            }
        }
    }
}
