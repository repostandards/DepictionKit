//
//  Tab.swift
//  DepictionKit
//
//  Created by Amy While on 07/03/2022.
//

import UIKit

final public class DepictionTab {
    
    internal var tintOverride: Color?
    internal var children: [DepictionView]
    internal var name: String
    
    enum Error: LocalizedError {
        case missing_children
        case missing_name
        
        public var errorDescription: String? {
            switch self {
            case .missing_children: return "Tab missing required argument: children"
            case .missing_name: return "Tab missing required argument: name"
            }
        }
    }
    
    init(_ dict: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?, in view: UIView) throws {
        var theme = theme
        if let _color = dict["tint_override"] as? [String: String] {
            let override = try Color(for: _color)
            theme = Theme(from: theme, with: override)
            tintOverride = override
        }
        guard let children = dict["children"] as? [[String: Any]],
              let name = dict["name"] as? String else { throw Error.missing_children }
        self.children = try DepictionView.depictionView(for: children, in: view, theme: theme, delegate: delegate)
        self.name = name
    }
    
    internal func themeDidChange(_ theme: Theme) {
        var theme = theme
        if let tintOverride = tintOverride {
            theme = Theme(from: theme, with: tintOverride)
        }
        children.forEach { $0.view.theme = theme }
    }
    
}
