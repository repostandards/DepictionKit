//
//  TableButton.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

struct TableButton: TableElementProperties {
    
    let text: String
    
    let icon: URL?
    
    let action: String
    
    let external: Bool
    
    let tint_override: Color?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.icon = try container.decodeIfPresent(URL.self, forKey: .icon)
        self.action = try container.decode(String.self, forKey: .action)
        self.external = try container.decodeIfPresent(Bool.self, forKey: .external) ?? false
        self.tint_override = try container.decodeIfPresent(Color.self, forKey: .tint_override)
    }
    
}
