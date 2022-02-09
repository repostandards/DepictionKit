//
//  DepictionView.swift
//  DepictionView
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

typealias AnyDepictionView = UIView & DepictionViewDelegate

/// Trampoline class for handling children views
internal class DepictionView {
    
    private let name: String
    private let properties: [String: Any]
    internal let view: AnyDepictionView
    
    enum Error: LocalizedError {
        case invalid_name(input: [String: Any])
        case invalid_properties(input: [String: Any])
        case invalid_view(view: String)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_name(input): return "Failed to parse name for \(input)"
            case let .invalid_properties(input): return "Failed to parse properties for \(input)"
            case let .invalid_view(view): return "\(view) is not a valid view type"
            }
        }
    }
    
    init(for input: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
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
            view = try TextView(for: properties, theme: theme, delegate: delegate)
        case "ScreenshotsView":
            view = try ScreenshotsView(for: properties, theme: theme, delegate: delegate)
        case "ImageView":
            view = try ImageView(for: properties, theme: theme, delegate: delegate)
        case "Rating":
            view = try Rating(for: properties, theme: theme, height: 30)
        case "Button":
            view = try Button(for: properties, theme: theme, delegate: delegate)
        case "TableView":
            view = try TableView(for: properties, theme: theme)
        case "PackageView":
            view = try PackageView(for: properties, theme: theme, delegate: delegate)
        case "PackageBannerList":
            view = try PackageBannerList(for: properties, theme: theme, delegate: delegate)
        default:
            view = Placeholder()
        }
        view.delegate = delegate
    }
    
    class func depictionView(for views: [[String: Any]], in containerView: UIView, theme: Theme, delegate: DepictionContainerDelegate?) throws -> [DepictionView] {
   
        let contentView = UIStackView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.distribution = .equalSpacing
        
        containerView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        var childrenViews = [DepictionView]()
        do {
            for view in views {
                let view = try DepictionView(for: view, theme: theme, delegate: delegate)
                childrenViews.append(view)
                contentView.addArrangedSubview(view.view)
                NSLayoutConstraint.activate([
                    view.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    view.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])
            }
        } catch {
            throw error
        }
        return childrenViews
    }
}
