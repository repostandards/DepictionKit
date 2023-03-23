//
//  View.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct View: Codable {
    
    let name: String
    
    let properties: ViewProperties
    
    enum CodingKeys: String, CodingKey {
        case name
        case properties
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        let type: ViewProperties.Type
        switch name {
        case "HeadingView": type = HeadingViewProperties.self
        case "TextView": type = TextViewProperties.self
        case "VideoView": type = VideoViewProperties.self
        case "ImageView": type = ImageViewProperties.self
        case "ScreenshotsView": type = ScreenshotsViewProperties.self
        case "TableView": type = TableViewProperties.self
        case "Button": type = ButtonProperties.self
        case "Separator": type = SeparatorProperties.self
        case "Spacer": type = SpacerProperties.self
        case "TabView": type = TabViewProperties.self
        case "StackView": type = StackViewProperties.self
        case "Rating": type = RatingProperties.self
        case "Review": type = ReviewProperties.self
        default: throw DecodingError.dataCorrupted(.init(codingPath:decoder.codingPath,
                                                         debugDescription: "The view \"\(name)\" is not implemented in this version."))
        }
        self.properties = try container.decode(type, forKey: .properties)
    }
    
    public init(name: String, properties: ViewProperties) {
        self.name = name
        self.properties = properties
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(properties, forKey: .properties)
        try container.encode(name, forKey: .name)
    }
    
}
