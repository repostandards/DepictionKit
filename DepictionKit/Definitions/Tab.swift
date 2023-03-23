//
//  Tab.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct Tab: Codable {
    
    let title: String
    
    let children: [View]
    
    public init(title: String, children: [View]) {
        self.title = title
        self.children = children
    }
    
}
