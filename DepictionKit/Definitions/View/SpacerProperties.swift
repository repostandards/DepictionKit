//
//  SpacerProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct SpacerProperties: ViewProperties {
    
    let spacing: Double
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.spacing = try container.decodeIfPresent(Double.self, forKey: .spacing) ?? 10
    }
    
    public init(spacing: Double = 10) {
        self.spacing = spacing
    }
    
}
