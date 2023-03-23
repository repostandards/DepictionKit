//
//  FontWeight.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import UIKit

public enum FontWeight: String, Codable {
    
    case ultralight = "ultralight"
    case thin = "thin"
    case light = "light"
    case regular = "regular"
    case medium = "medium"
    case semibold = "semibold"
    case bold = "bold"
    case heavy = "heavy"
    case black = "black"
    
    internal var fontWeight: UIFont.Weight {
        switch self {
        case .ultralight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
    
}
