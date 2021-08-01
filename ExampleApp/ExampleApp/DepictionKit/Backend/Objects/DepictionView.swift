//
//  DepictionView.swift
//  DepictionView
//
//  Created by Andromeda on 01/08/2021.
//

import Foundation

/// Trampoline class for handling children views
public final class DepictionView {
    
    private let name: String
    private let properties: [String: AnyHashable]
    
    enum Error: LocalizedError {
        case invalid_name(input: [String: AnyHashable])
        case invalid_properties(input: [String: AnyHashable])
        case invalid_view(view: String)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_name(input): return "Failed to parse name for \(input)"
            case let .invalid_properties(input): return "Failed to parse properties for \(input)"
            case let .invalid_view(view): return "\(view) is not a valid view type"
            }
        }
    }
    
    init(for input: [String: AnyHashable]) throws {
        guard let name = input["name"] as? String else { throw DepictionView.Error.invalid_name(input: input) }
        guard let properties = input["properties"] as? [String: AnyHashable] else { throw DepictionView.Error.invalid_properties(input: input) }
        self.name = name
        self.properties = properties
    }
}
