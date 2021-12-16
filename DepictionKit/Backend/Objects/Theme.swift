//
//  Theme.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/**
DepictionKit requires the app to provide a Theme object so that the Depiction will fit in with the rest of your design.
 
 - Author: Amy

 - Version: 1.0
 */
public final class Theme {
    
    static let change = Notification.Name("DepictionKit.ThemeChange")
    
    internal let text_color: UIColor
    internal let background_color: UIColor
    internal var tint_color: UIColor
    internal let separator_color: UIColor
    internal let dark_mode: Bool
    
    /**
    Create a Theme object to be used in the Depiction
          
     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - text_color: The color to be used for text
        - background_color: The background colour of the Depiction
        - tint_color: The fallback tint color of the depiction. This may be overriden by the depiction
        - separator_color: The colour to be used by `Separator`
        - dark_mode: If the apps theme is currently set to a dark theme
     */
    public init(text_color: UIColor,
                background_color: UIColor,
                tint_color: UIColor,
                separator_color: UIColor,
                dark_mode: Bool) {
        self.text_color = text_color
        self.background_color = background_color
        self.tint_color = tint_color
        self.separator_color = separator_color
        self.dark_mode = dark_mode
    }
    
    internal init(from: Theme, with tint_color: Color) {
        self.tint_color =  from.dark_mode ? tint_color.dark_mode : tint_color.light_mode
        self.text_color = from.text_color
        self.background_color = from.background_color
        self.separator_color = from.separator_color
        self.dark_mode = from.dark_mode
    }
}
