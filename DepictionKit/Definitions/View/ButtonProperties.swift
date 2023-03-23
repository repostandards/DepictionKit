//
//  ButtonProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct ButtonProperties: ViewProperties, TintOverrideProperty {
    
    let children: [View]
    
    let action: String
    
    let external: Bool
    
    let tint_override: Color?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.children = try container.decode([View].self, forKey: .children)
        self.action = try container.decode(String.self, forKey: .action)
        self.external = try container.decodeIfPresent(Bool.self, forKey: .external) ?? false
        self.tint_override = try container.decodeIfPresent(Color.self, forKey: .tint_override)
    }
    
    public init(children: [View], action: String, external: Bool = false, tint_override: Color? = nil) {
        self.children = children
        self.action = action
        self.external = external
        self.tint_override = tint_override
    }
    
}
