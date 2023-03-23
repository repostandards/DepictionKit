//
//  TextViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

/// https://github.com/repostandards/depiction-schema/blob/a389a08caf97035fce4e669f10d1ba4bdbc2be5b/definitions/Views.d.ts#LL57
public struct TextViewProperties: ViewProperties, TintOverrideProperty {
   
    let content: String
 
    let format: TextFormatting
    
    let tint_override: Color?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.format = try container.decodeIfPresent(TextFormatting.self, forKey: .format) ?? .markdown
        self.tint_override = try container.decodeIfPresent(Color.self, forKey: .tint_override)
    }
    
    public init(content: String, format: TextFormatting = .markdown, tint_override: Color? = nil) {
        self.content = content
        self.format = format
        self.tint_override = tint_override
    }

}
