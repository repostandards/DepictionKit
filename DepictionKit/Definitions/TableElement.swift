//
//  TableElement.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct TableElement: Codable {
    
    let name: String
    
    let properties: TableElementProperties
    
    enum CodingKeys: String, CodingKey {
        case name
        case properties
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        switch name {
        case "TableItem": self.properties = try container.decode(TableItem.self, forKey: .properties)
        case "TableButton": self.properties = try container.decode(TableButton.self, forKey: .properties)
        default: throw DecodingError.dataCorrupted(.init(codingPath:decoder.codingPath,
                                                         debugDescription: "The table element \"\(name)\" is not implemented in this version."))
        }
    }
    
    public init(name: String, properties: TableElementProperties) {
        self.name = name
        self.properties = properties
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(properties, forKey: .properties)
        try container.encode(name, forKey: .name)
    }
    
}
