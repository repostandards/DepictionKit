//
//  Screenshot.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import CoreGraphics
import Foundation

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
    public var attachment: Attachment?
    public var theme: Theme
    
    public var displayURL: URL {
        if let attachment = attachment {
            return attachment.url(for: theme)
        }
        return url
    }
    
    init(for input: [String: Any], theme: Theme) throws {
        let url: URL
        if let _url = input["url"] as? String,
           let static_url = URL(string: _url) {
            url = static_url
        } else if let _attachment = input["attachment"] as? [String: Any],
                  let attachment = Attachment(_attachment) {
            self.attachment = attachment
            url = attachment.url(for: theme)
        } else {
            throw Error.invalid_url(url: input["url"] as? String ?? "nil")
        }
        guard let alt_text = input["alt_text"] as? String else { throw Screenshot.Error.missing_alt_text }
        self.alt_text = alt_text
        self.url = url
        
        if let content_size = input["content_size"] as? [String: Int] {
            guard let width = content_size["width"],
                  let height = content_size["height"] else { throw Error.invalid_content_size }
            self.height = CGFloat(height)
            self.width = CGFloat(width)
        }
        self.theme = theme
    }
    
}
