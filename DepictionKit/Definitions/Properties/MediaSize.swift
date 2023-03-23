//
//  MediaSize.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct MediaSize: Codable {
    
    let width: Double
    let height: Double
    
    public init(width: Double, height: Double) {
        self.width = width
        self.height = height
    }
}
