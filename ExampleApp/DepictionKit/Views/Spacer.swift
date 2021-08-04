//
//  Spacer.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

final public class Spacer: UIView {

    
    init(input: [String: Any]) {
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
