//
//  Spacer.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/**
 Create artificial spacing between Depiction elements
      
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - spacing: `Int? = 10`; Customize the spacing value
 */
final public class Spacer: UIView, DepictionViewDelegate {

    init(for input: [String: Any]) {
        var spacing = 10
        if let _spacing = input["spacing"] as? Int {
            spacing = _spacing
        }
        super.init(frame: .zero)
        heightAnchor.constraint(equalToConstant: CGFloat(spacing)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
