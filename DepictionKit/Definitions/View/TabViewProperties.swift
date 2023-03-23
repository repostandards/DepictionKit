//
//  TabViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct TabViewProperties: ViewProperties {
    
    let tabs: [Tab]
    
    public init(tabs: [Tab]) {
        self.tabs = tabs
    }
    
}
