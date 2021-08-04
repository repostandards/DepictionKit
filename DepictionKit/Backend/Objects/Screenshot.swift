//
//  Screenshot.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import CoreGraphics

final public class Screenshot {
    
    enum Error: LocalizedError {
        case missing_url
        case invalid_url(url: String)
        case missing_alt_text
        case invalid_content_size
        
        public var errorDescription: String? {
            switch self {
            case .missing_url: return "Screenshot missing required argument: url"
            case let .invalid_url(url): return "Screenshot has invalid URL \(url)"
            case .missing_alt_text: return "Screenshot is missing required arugment: alt_text"
            case .invalid_content_size: return "Screenshot has invalid content size"
            }
        }
    }
    
    public var url: URL
    public var alt_text: String
    public var height: CGFloat?
    public var width: CGFloat?
    
    init(for input: [String: Any]) throws {
        guard let _url = input["url"] as? String else { throw Screenshot.Error.missing_url }
        guard let url = URL(string: _url) else { throw Screenshot.Error.invalid_url(url: _url) }
        guard let alt_text = input["alt_text"] as? String else { throw Screenshot.Error.missing_alt_text }
        self.alt_text = alt_text
        self.url = url
        
        if let content_size = input["content_size"] as? [String: Int] {
            guard let width = content_size["width"],
                  let height = content_size["height"] else { throw Error.invalid_content_size }
            self.height = CGFloat(height)
            self.width = CGFloat(width)
        }
    }
    
}
