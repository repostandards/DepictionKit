//
//  Screenshot.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct Screenshot: Codable {
    
    let url: URL
    
    let alt_text: String
    
    public init(url: URL, alt_text: String) {
        self.url = url
        self.alt_text = alt_text
    }
    
}
