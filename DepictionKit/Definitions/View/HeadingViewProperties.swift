//
//  HeadingViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

/// https://github.com/repostandards/depiction-schema/blob/a389a08caf97035fce4e669f10d1ba4bdbc2be5b/definitions/Views.d.ts#LL16
public struct HeadingViewProperties: ViewProperties {
    
    let text: String
    
    let level: Int
    
    let auto_wrap: Bool
    
    let text_color: Color?
    
    let font_weight: FontWeight
    
    let alignment: Alignment
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.level = try container.decodeIfPresent(Int.self, forKey: .level) ?? 1
        guard level > 0 && level < 4 else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Heading level must be between 1 and 3"))
        }
        self.auto_wrap = try container.decodeIfPresent(Bool.self, forKey: .auto_wrap) ?? true
        self.text_color = try container.decodeIfPresent(Color.self, forKey: .text_color)
        self.font_weight = try container.decodeIfPresent(FontWeight.self, forKey: .font_weight) ?? .semibold
        self.alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? .left
    }

    public init(text: String, level: Int = 1, auto_wrap: Bool = true, text_color: Color? = nil, font_weight: FontWeight = .semibold, alignment: Alignment = .left) {
        self.text = text
        self.level = level
        self.auto_wrap = auto_wrap
        self.text_color = text_color
        self.font_weight = font_weight
        self.alignment = alignment
    }
    
}
