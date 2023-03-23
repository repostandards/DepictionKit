//
//  DepictionView.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import UIKit

internal class DepictionView: UIView {
    
    private final let theme: Color
    internal final var systemTheme: NativeDepictionTheme
    internal final weak var parentDelegate: DepictionViewDelegate?
    
    internal var depictionTintColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { [weak self] traitCollection in
                guard let self else { return .clear }
                return self.darkMode ? self.theme.dark_theme : self.theme.light_theme
            }
        } else {
            // Fallback on earlier versions
            return self.darkMode ? self.theme.dark_theme : self.theme.light_theme
        }
    }
    
    internal var darkMode: Bool {
        if #available(iOS 12.0, *) {
            return self.systemTheme.darkMode ?? (traitCollection.userInterfaceStyle == .dark)
        } else {
            // Fallback on earlier versions
            return self.systemTheme.darkMode ?? false
        }
    }
    
    internal init(properties: ViewProperties, parentTheme: Color, systemTheme: NativeDepictionTheme, parentDelegate: DepictionViewDelegate?) {
        if let tintOverrideProperties = properties as? TintOverrideProperty,
           let tintOverride = tintOverrideProperties.tint_override {
            self.theme = tintOverride
        } else {
            self.theme = parentTheme
        }
        self.systemTheme = systemTheme
        self.parentDelegate = parentDelegate
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
