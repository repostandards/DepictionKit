//
//  DepictionView.swift
//  DepictionView
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

typealias AnyDepictionView = UIView & DepictionViewDelegate

/// Trampoline class for handling children views
public final class DepictionView {
    
    private let name: String
    private let properties: [String: AnyHashable]
    internal let view: AnyDepictionView
    
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
    
    init(for input: [String: AnyHashable], theme: Theme, delegate: DepictionContainerDelegate) throws {
        guard let name = input["name"] as? String else { throw Error.invalid_name(input: input) }
        let properties = input["properties"] as? [String: AnyHashable] ?? [String: AnyHashable]()
        self.name = name
        self.properties = properties
        switch name {
        case "HeadingView":
            view = try HeadingView(for: properties, theme: theme)
        case "VideoView":
            view = try VideoView(for: properties)
        case "Separator":
            view = try Separator(for: properties, theme: theme)
        case "Spacer":
            view = Spacer(for: properties)
        case "TextView":
            view = try TextView(for: properties, theme: theme)
        case "ScreenshotsView":
            view = try ScreenshotsView(for: properties, theme: theme)
        case "ImageView":
            view = try ImageView(for: properties, theme: theme)
        case "Rating":
            view = try Rating(for: properties, theme: theme, height: 30)
        default:
            view = Placeholder()
        }
        view.delegate = delegate
    }
}
