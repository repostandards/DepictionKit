//
//  Theme.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

public final class Theme {
    
    static let change = Notification.Name("DepictionKit.ThemeChange")
    
    public let text_color: UIColor
    public let background_color: UIColor
    public let tint_color: UIColor
    public let dark_mode: Bool
    
    init(text_color: UIColor, background_color: UIColor, tint_color: UIColor, dark_mode: Bool) {
        self.text_color = text_color
        self.background_color = background_color
        self.tint_color = tint_color
        self.dark_mode = dark_mode
    }
    
}
