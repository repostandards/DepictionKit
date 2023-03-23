//
//  Depiction.swift
//  Depiction
//
//  Created by Andromeda on 01/08/2021.
//

import Foundation

final internal class Depiction {
    
    enum Error: LocalizedError {
        case missing_schema
        case missing_children
        case empty_children
        
        public var errorDescription: String? {
            switch self {
            case .missing_schema: return "Depiction missing required argument: $schema"
            case .missing_children: return "Depiction missing required argument: children"
            case .empty_children: return "Argument children must have at least one object"
            }
        }
    }
    
    internal let schema: String
    internal let tint_color: Color?
    internal let children: [DepictionView]
 
    init(json: [String: Any], theme: Theme, delegate: DepictionContainerDelegate) throws {
        guard let schema = json["$schema"] as? String ?? json["schema"] as? String else {
            throw Depiction.Error.missing_schema
        }
        self.schema = schema
        
        var tint_color: Color?
        if let _tint_color = json["tint_color"] {
            do {
                tint_color = try Color(for: _tint_color, inferDarkColorIfNeeded: true)
            } catch {
                throw error
            }
        }
        self.tint_color = tint_color

        let effectiveTheme = theme
        if let tintColor = tint_color?.color(for: theme) {
            effectiveTheme.tint_color = tintColor
        }
        
        guard let children = json["children"] as? [[String: AnyHashable]] else {
            throw Depiction.Error.missing_children
        }
        
        guard !children.isEmpty else {
            throw Depiction.Error.empty_children
        }
        
        var childrenViews = [DepictionView]()
        do {
            for child in children {
                let view = try DepictionView(for: child, theme: effectiveTheme, delegate: delegate)
                childrenViews.append(view)
            }
        } catch {
            throw error
        }
        
        self.children = childrenViews
    }
}
