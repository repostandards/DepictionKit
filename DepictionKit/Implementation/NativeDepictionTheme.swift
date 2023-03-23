//
//  NativeDepictionTheme.swift
//  DepictionKit
//
//  Created by Amy While on 27/11/2022.
//

import UIKit

/// An object passed into `NativeDepictionView` that represents the theme of the parent application.
/// If parameters change you should make a new theme object and pass that into the view, instead of modifying an existing object.
/// It is recommended to use UIColors with dynamic providers for these properties to maximise performance
public class NativeDepictionTheme {
    
    internal let textColor: UIColor

    internal let separatorColor: UIColor

    internal let darkMode: Bool?
    
    
    /// Create a theme object to be used in `NativeDepictionView`
    /// - Parameters:
    ///   - textColor: This is the color that will be used to render text in the depiction
    ///   - separatorColor: The fill color for separator objects
    ///   - darkMode: If the parent application is currently in an overriden darkmode. Leave this property nil if you wish to rely on the UITraitCollection
    public init(textColor: UIColor, separatorColor: UIColor, darkMode: Bool? = nil) {
        self.textColor = textColor
        self.separatorColor = separatorColor
        self.darkMode = darkMode
    }
    
}
