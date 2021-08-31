//
//  Button.swift
//  DepictionKit
//
//  Created by Andromeda on 31/08/2021.
//

import UIKit

final class Button: UIView, DepictionViewDelegate {
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    internal weak var delegate: DepictionContainerDelegate?
    public var depictionChildren: [DepictionView]?
    public var tintOverride: Color?
    public var action: String
    public var external: Bool
    
    enum Error: LocalizedError {
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
        
        if let _color = properties["tint_override"] as? Color {
            do {
                tintOverride = try Color(for: _color)
                theme.tint_color = theme.dark_mode ? tintOverride!.dark_mode : tintOverride!.light_mode
            } catch {
                throw error
            }
        }
        
        self.action = action
        self.external = external
        self.theme = theme
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        do {
            self.depictionChildren = try DepictionView.depictionView(for: children, in: self, theme: theme, delegate: delegate)
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
            control.bottomAnchor.constraint(equalTo: bottomAnchor),
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
            theme.tint_color = theme.dark_mode ? tintOverride.dark_mode : tintOverride.light_mode
        }
        depictionChildren?.forEach { $0.view.theme = theme }
    }
}
