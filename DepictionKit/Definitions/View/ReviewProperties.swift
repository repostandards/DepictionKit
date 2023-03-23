//
//  ReviewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct ReviewProperties: ViewProperties, TintOverrideProperty {
    
    let title: String
    
    let author: String?
    
    let body: String
    
    let format: TextFormatting
    
    let rating: Double?
    
    let tint_override: Color?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.body = try container.decode(String.self, forKey: .body)
        self.format = try container.decodeIfPresent(TextFormatting.self, forKey: .format) ?? .markdown
        if let rating = try container.decodeIfPresent(Double.self, forKey: .rating) {
            guard rating >= 0 && rating <= 5 else {
                throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Rating  ust be between 0 and 5"))
            }
            self.rating = rating
        } else {
            self.rating = nil
        }
        self.tint_override = try container.decodeIfPresent(Color.self, forKey: .tint_override)
    }
    
    public init(title: String, author: String? = nil, body: String, format: TextFormatting = .markdown, rating: Double? = nil, tint_override: Color? = nil) {
        self.title = title
        self.author = author
        self.body = body
        self.format = format
        self.rating = rating
        self.tint_override = tint_override
    }
    
}
