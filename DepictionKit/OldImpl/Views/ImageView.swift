//
//  ImageView.swift
//  DepictionKit
//
//  Created by Andromeda on 16/08/2021.
//

import UIKit

/**
 Embed an image in a view
 - Author: Amy

 - Version: 1.0
 
 - Important: Only one of `url` or `attachment` are required. Do not add both.
 
 - Parameters:
    - url: `String`; URL to the image content.
    - attachment: `Attachment`; Attachment to the image content
    - alt_text: `String`; Accessbility Text to improve the reliability of Screen readers.
    - image_size: `[String: Int]`; Size of the image in pts. Requires the keys `width` and `height`
    - player: `String? = "native"`;  Video player type (Embedded player or Web View).
                                    For sites like YouTube or Vimeo which don't give native video, using the web player is the only option.
                                    Supports `native` and `web`
    - corner_radius: `Int? = 4`; Image corner radius.
    - alignment: `Alignment? = "left"`; Set the alignment of the image.
 */
final public class ImageView: UIView, DepictionViewDelegate {
    
    private var imageView: NetworkImageView?
    private var attachment: Attachment?
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    
    private enum Error: LocalizedError {
        case invalid_url(string: String?)
        case invalid_alt_text
        case invalid_image_size
        case unknown_alignment_error
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_url(string): return "\(string ?? "Nil") is an invalid URL"
            case .invalid_alt_text: return "ImageView is missing required argument: alt_text"
            case .invalid_image_size: return "ImageView has invalid argument: image_size"
            case .unknown_alignment_error: return "ImageView had unknown alignment error"
            }
        }
    }

    init(for input: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
        let url: URL
        if let _url = input["url"] as? String,
           let static_url = URL(string: _url) {
            url = static_url
        } else if let _attachment = input["attachment"] as? [String: Any],
                  let attachment = Attachment(_attachment) {
            self.attachment = attachment
            url = attachment.url(for: theme)
        } else {
            throw Error.invalid_url(string: input["url"] as? String)
        }
        guard let alt_text = input["alt_text"] as? String else { throw Error.invalid_alt_text }
        guard let image_size = input["image_size"] as? [String: Int],
              let height = image_size["height"],
              let width = image_size["width"] else { throw Error.invalid_image_size }
        
        var alignment: NSTextAlignment = .left
        if let _alignment = input["alignment"] as? String {
            do {
                alignment = try Alignment.alignment(for: _alignment)
            } catch {
                throw error
            }
        }
        
        self.theme = theme
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        let cornerRadius = input["corner_radius"] as? Int ?? 4
        
        let correctUrl: URL = {
            if let attachment = attachment {
                return attachment.url(for: theme)
            }
            return url
        }()
        let imageView = NetworkImageView(url: correctUrl, delegate: delegate)
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = CGFloat(cornerRadius)
        imageView.delegate = delegate
        if #available(iOS 13, *) {
            imageView.layer.cornerCurve = .continuous
        }
        imageView.accessibilityLabel = alt_text
        addSubview(imageView)
        
        var constraints: [NSLayoutConstraint] = [
            imageView.aspectRatioConstraint(CGFloat(height) / CGFloat(width)),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: CGFloat(width))
        ]
        
        switch alignment {
        case .left:
            constraints.append(imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15))
            constraints.append(imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15))
            let lesserTrailing = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
            lesserTrailing.priority = UILayoutPriority(750)
            constraints.append(lesserTrailing)
        case .right:
            constraints.append(imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15))
            constraints.append(imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15))
            let lesserLeading = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
        case .center:
            constraints.append(imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15))
            constraints.append(imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15))
            constraints.append(imageView.centerXAnchor.constraint(equalTo: centerXAnchor))
            let lesserLeading = imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
            let lesserTrailing = imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
            lesserTrailing.priority = UILayoutPriority(750)
            constraints.append(lesserTrailing)
        default: throw Error.unknown_alignment_error
        }
    
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        guard let imageView = imageView,
              let attachment = attachment else {
            // We haven't got past init yet
            return
        }
        let url = attachment.url(for: theme)
        if imageView.url != url {
            imageView.url = url
            imageView.fetchImage()
        }
    }
}
