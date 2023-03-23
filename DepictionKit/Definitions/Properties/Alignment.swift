//
//  Alignment.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import UIKit

public enum Alignment: String, Codable {
    
    case left = "left"
    case center = "center"
    case right = "right"
    
    internal var textAlignment: NSTextAlignment {
        switch self {
        case .left: return .left
        case .center: return .center
        case .right: return .right
        }
    }

}
