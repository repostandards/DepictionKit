//
//  ScreenshotsViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct ScreenshotsViewProperties: ViewProperties {
    
    let screenshots: [Screenshot]
    
    let corner_radius: Double
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.screenshots = try container.decode([Screenshot].self, forKey: .screenshots)
        self.corner_radius = try container.decodeIfPresent(Double.self, forKey: .corner_radius) ?? 4 
    }
    
    public init(screenshots: [Screenshot], corner_radius: Double = 4) {
        self.screenshots = screenshots
        self.corner_radius = corner_radius
    }
    
}
