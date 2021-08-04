//
//  DepictionView.swift
//  DepictionView
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/// Trampoline class for handling children views
public final class DepictionView {
    
    private let name: String
    private let properties: [String: AnyHashable]
    internal let view: UIView
    
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
    
    init(for input: [String: AnyHashable], theme: Theme) throws {
        guard let name = input["name"] as? String else { throw DepictionView.Error.invalid_name(input: input) }
        let properties = input["properties"] as? [String: AnyHashable] ?? [String: AnyHashable]()
        self.name = name
        self.properties = properties
        switch name {
        case "HeadingView":
            do {
                view = try HeadingView(input: properties, theme: theme)
            } catch {
                throw error
            }
        case "VideoView":
            do {
                view = try VideoView(input: properties)
            } catch {
                throw error
            }
        case "Separator":
            do {
                view = try Separator(input: properties, theme: theme)
            } catch {
                throw error
            }
        case "Spacer": view = Spacer(input: properties)
        case "TextView":
            do {
                view = try TextView(input: properties, theme: theme)
            } catch {
                throw error
            }
        default:
            view = UIView()
        }
    }
}
