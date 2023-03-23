//
//  ImageViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

/// https://github.com/repostandards/depiction-schema/blob/a389a08caf97035fce4e669f10d1ba4bdbc2be5b/definitions/Views.d.ts#L148
public struct ImageViewProperties: ViewProperties {

    let url: URL
    
    let alt_text: String

    let image_size: MediaSize
    
    let corner_radius: Double
    
    let alignment: Alignment
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(URL.self, forKey: .url)
        self.alt_text = try container.decode(String.self, forKey: .alt_text)
        self.image_size = try container.decode(MediaSize.self, forKey: .image_size)
        self.corner_radius = try container.decodeIfPresent(Double.self, forKey: .corner_radius) ?? 4
        self.alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? .left
    }
    
    public init(url: URL, alt_text: String, image_size: MediaSize, corner_radius: Double = 4, alignment: Alignment = .left) {
        self.url = url
        self.alt_text = alt_text
        self.image_size = image_size
        self.corner_radius = corner_radius
        self.alignment = alignment
    }
    
}
