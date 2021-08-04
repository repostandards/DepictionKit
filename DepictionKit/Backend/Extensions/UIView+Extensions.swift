//
//  UIView+Extensions.swift
//  ExampleApp
//
//  Created by Andromeda on 02/08/2021.
//

import UIKit

internal extension UIView {
    
    func aspectRatioConstraint(_ ratio: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint(item: self,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .width,
                           multiplier: ratio,
                           constant: 0)
    }
    
}
