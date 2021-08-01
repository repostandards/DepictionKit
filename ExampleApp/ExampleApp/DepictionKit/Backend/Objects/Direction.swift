//
//  Direction.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import Foundation

/// Class to generate alignment
public enum Alignment {
    
    case horizontal
    case vertical
    
    init(input: String) throws {
        switch input {
        case "horizontal": self = .horizontal
        case "vertical": self = .vertical
        default: throw Alignment.Error.invalid_alignment(input: input)
        }
    }
    
    enum Error: LocalizedError {
        case invalid_alignment(input: String)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_alignment(input): return "Alignment`\(input)` is invalid"
            }
        }
    }
}
