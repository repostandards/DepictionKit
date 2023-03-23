//
//  Color.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import UIKit

public struct Color: Codable {
    
    let light_theme: UIColor
    let dark_theme: UIColor
    
    enum CodingKeys: String, CodingKey {
        case light_theme
        case dark_theme
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            let light = try container.decode(String.self, forKey: .light_theme)
            let dark = try container.decode(String.self, forKey: .dark_theme)
            guard let light_theme = UIColor(hex: light),
                  let dark_theme = UIColor(hex: dark) else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid Hex Color"))
            }
            self.light_theme = light_theme
            self.dark_theme = dark_theme
        } else {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            guard let color = UIColor(hex: string) else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Invalid Hex Color"))
            }
            self.light_theme = color
            self.dark_theme = color
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(light_theme.hex, forKey: .light_theme)
        try container.encode(dark_theme.hex, forKey: .dark_theme)
    }
    
    internal init(light_theme: UIColor, dark_theme: UIColor) {
        self.light_theme = light_theme
        self.dark_theme = dark_theme
    }
    
}
