//
//  NativeDepiction.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public class NativeDepiction: Codable {
    
    let tint_color: Color
    
    let children: [View]
    
    public init(tint_color: Color, children: [View]) {
        self.tint_color = tint_color
        self.children = children
    }
    
}
