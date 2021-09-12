//
//  Attachment.swift
//  DepictionKit
//
//  Created by Andromeda on 25/08/2021.
//

import UIKit

/**
 A dynamic attachment for different themes and device sizes.
 
 DepictionKit supports customising the media that will show in the Depiction based on if its an iPhone or iPad
 and if the Depiction is in light or dark mode.
      
 - Important: If the `ipad` dict is not present it will fall back to `iphone`
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - iphone: `[String: String]`; Required keys are `light`and `dark`
    - ipad: `[String: String]?`; Required keys are `light` and `dark`
 */
public final class Attachment {
    
    private var iphone_light: URL
    private var iphone_dark: URL
    private var ipad_light: URL?
    private var ipad_dark: URL?
    
    init?(_ dict: [String: Any]) {
        if let ipad = dict["ipad"] as? [String: String] {
            guard let _light = ipad["light"],
                  let _dark = ipad["dark"],
                  let light = URL(string: _light),
                  let dark = URL(string: _dark) else { return nil }
            self.ipad_light = light
            self.ipad_dark = dark
        }
        if let iphone = dict["iphone"] as? [String: String] {
            guard let _light = iphone["light"],
                  let _dark = iphone["dark"],
                  let light = URL(string: _light),
                  let dark = URL(string: _dark) else { return nil }
            self.iphone_light = light
            self.iphone_dark = dark
            return
        }
        
        guard let _light = dict["light"] as? String,
              let _dark = dict["dark"] as? String,
              let light = URL(string: _light),
              let dark = URL(string: _dark) else { return nil }
        self.iphone_light = light
        self.iphone_dark = dark
    }
    
    internal func url(for theme: Theme) -> URL {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if theme.dark_mode {
                if let ipad_dark = ipad_dark {
                    return ipad_dark
                }
            }
            if let ipad_light = ipad_light {
                return ipad_light
            }
        }
        return theme.dark_mode ? iphone_dark : iphone_light
    }
}
