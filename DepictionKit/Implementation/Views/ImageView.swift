//
//  ImageView.swift
//  DepictionKit
//
//  Created by Amy While on 27/11/2022.
//

import UIKit

internal class ImageView: DepictionView {

    override init(properties: ViewProperties, parentTheme: Color, systemTheme: NativeDepictionTheme, parentDelegate: DepictionViewDelegate?) {
        super.init(properties: properties, parentTheme: parentTheme, systemTheme: systemTheme, parentDelegate: parentDelegate)
        
        let properties = properties as! ImageViewProperties
        
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityLabel = properties.alt_text
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            imageView.layer.cornerCurve = .continuous
        }
        imageView.layer.cornerRadius = properties.corner_radius
        imageView.contentMode = .scaleAspectFit
        
        parentDelegate?.depictionView(self, requesting: properties.url, completion: { image in
            imageView.image = image
        })
        
        addSubview(imageView)
        
        var constraints: [NSLayoutConstraint] = [
            imageView.aspectRatioConstraint(properties.image_size.height / properties.image_size.width),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant: properties.image_size.width)
        ]
        
        switch properties.alignment {
        case .left:
            constraints.append(imageView.leadingAnchor.constraint(equalTo: leadingAnchor))
            constraints.append(imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor))
            let lesserTrailing = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            lesserTrailing.priority = UILayoutPriority(750)
            constraints.append(lesserTrailing)
        case .right:
            constraints.append(imageView.trailingAnchor.constraint(equalTo: trailingAnchor))
            constraints.append(imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
            let lesserLeading = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
        case .center:
            constraints.append(imageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor))
            constraints.append(imageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor))
            constraints.append(imageView.centerXAnchor.constraint(equalTo: centerXAnchor))
            let lesserLeading = imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
            let lesserTrailing = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            lesserTrailing.priority = UILayoutPriority(750)
            constraints.append(lesserTrailing)
        }
    
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
