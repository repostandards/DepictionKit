//
//  Button.swift
//  DepictionKit
//
//  Created by Andromeda on 31/08/2021.
//

import UIKit

/**
Create a customizable button with subviews.
      
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - children: `[DepictionView]`; Array of subviews to show inside the button
    - action: `String`; The action to invoke when pressing the button. You can learn more about
                            actions in `DepictionAction`
    - external: `Bool? = false`;  Should the action open in an external app if possible
    - tint_override: `Color?`; Override the tint color of the button and its children
 */
final public class Button: UIView, DepictionViewDelegate {
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    internal weak var delegate: DepictionContainerDelegate?
    private var depictionChildren: [DepictionView]?
    private var tintOverride: Color?
    private var action: String
    private var external: Bool
    
    private enum Error: LocalizedError {
        case invalid_children
        case invalid_action
        
        public var errorDescription: String? {
            switch self {
            case .invalid_children: return "Button is missing required properties: children"
            case .invalid_action: return "Button is missing required properties: action"
            }
        }
    }
    
    init(for properties: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
        guard let children = properties["children"] as? [[String: Any]] else { throw Error.invalid_children }
        guard let action = properties["action"] as? String else { throw Error.invalid_action }
        
        var external = false
        if let _external = properties["external"] as? Bool {
            external = _external
        }
        
        self.theme = theme
        if let _color = properties["tint_override"] as? [String: String] {
            do {
                tintOverride = try Color(for: _color)
                self.theme = Theme(from: theme, with: tintOverride!)
            } catch {
                throw error
            }
        }
        
        self.action = action
        self.external = external
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        do {
            self.depictionChildren = try DepictionView.depictionView(for: children, in: self, theme: self.theme, delegate: delegate)
        } catch {
            throw error
        }
        
        backgroundColor = .clear
        let control = UIControl()
        control.backgroundColor = .clear
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        addSubview(control)
        NSLayoutConstraint.activate([
            control.topAnchor.constraint(equalTo: topAnchor),
            control.leadingAnchor.constraint(equalTo: leadingAnchor),
            control.trailingAnchor.constraint(equalTo: trailingAnchor),
            control.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func buttonPressed() {
        delegate?.handleAction(action: action, external: external)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        if let tintOverride = tintOverride {
            theme = Theme(from: theme, with: tintOverride)
        }
        depictionChildren?.forEach { $0.view.theme = theme }
    }
}
