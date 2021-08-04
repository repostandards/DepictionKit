//
//  UIImage+Extensions.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import UIKit

// iOS 15 adds a prepare for display method which makes showing images far more optimised
// This is a recreation of that function, recommended to call from a background thread

extension UIImage {
    
    internal func prepareForDisplay() -> UIImage {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let data = pngData() as CFData?,
              let imageSource = CGImageSourceCreateWithData(data, imageSourceOptions) else { return self }
        let maxDimentionInPixels = max(size.width, size.height) * UIScreen.main.scale
        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
          kCGImageSourceShouldCacheImmediately: true,
          kCGImageSourceCreateThumbnailWithTransform: true,
          kCGImageSourceThumbnailMaxPixelSize: maxDimentionInPixels] as CFDictionary
        guard let downScaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions) else { return self }
        return UIImage(cgImage: downScaledImage)
    }
    
}
