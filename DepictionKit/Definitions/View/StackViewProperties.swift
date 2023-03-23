//
//  StackViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct StackViewProperties: ViewProperties {
    
    let children: [View]
    
    let orientation: Orientation
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.children = try container.decode([View].self, forKey: .children)
        self.orientation = try container.decodeIfPresent(Orientation.self, forKey: .orientation) ?? .vertical
    }
    
    public init(children: [View], orientation: Orientation = .vertical) {
        self.children = children
        self.orientation = orientation
    }
    
}
