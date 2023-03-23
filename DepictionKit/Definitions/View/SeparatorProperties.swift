//
//  SeparatorProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct SeparatorProperties: ViewProperties {

    let direction: Orientation
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.direction = try container.decodeIfPresent(Orientation.self, forKey: .direction) ?? .horizontal
    }
    
    public init(direction: Orientation = .horizontal) {
        self.direction = direction
    }
    
}
