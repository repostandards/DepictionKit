//
//  Screenshot.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import CoreGraphics
import Foundation

/**
 Screenshots are shown in `ScreenshotView`
       
 - Important: Only one of `url` or `attachment` are required. Do not add both.
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - url: `String`; URL location of the specified image, gif, or raw video.
    - attachment: `Attachment`; Attachment for screenshot content
    - alt_text: `String`; Accessibility Text to improve the reliability of Screen readers.
    - content_size: `[String: Int]`;  Size of the screenshot in pts. Requires the keys `width` and `height`
 */
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
    
    internal var url: URL
    internal var alt_text: String
    internal var height: CGFloat?
    internal var width: CGFloat?
    internal var attachment: Attachment?
    internal var theme: Theme
    
    internal var displayURL: URL {
        if let attachment = attachment {
            return attachment.url(for: theme)
        }
        return url
    }
    
    init(for input: [String: Any], theme: Theme, content_size: [String: Int]?) throws {
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
        
        guard let content_size = input["content_size"] as? [String: Int] ?? content_size,
              let width = content_size["width"],
              let height = content_size["height"] else {
            throw Error.invalid_content_size
        }
        
        self.height = CGFloat(height)
        self.width = CGFloat(width)
        self.theme = theme
    }
    
}
