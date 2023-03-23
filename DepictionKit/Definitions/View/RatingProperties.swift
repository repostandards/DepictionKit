//
//  RatingProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct RatingProperties: ViewProperties {
    
    let rating: Double
    
    let alignment: Alignment
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rating = try container.decode(Double.self, forKey: .rating)
        guard rating >= 0 && rating <= 5 else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Rating  ust be between 0 and 5"))
        }
        self.alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? .left
    }
    
    public init(rating: Double, alignment: Alignment = .left) {
        self.rating = rating
        self.alignment = alignment
    }
    
}
