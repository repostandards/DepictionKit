//
//  HeadingView.swift
//  DepictionKit
//
//  Created by Amy While on 27/11/2022.
//

import UIKit

internal class HeadingView: DepictionView {
    
    override init(properties: ViewProperties, parentTheme: Color, systemTheme: NativeDepictionTheme, parentDelegate: DepictionViewDelegate?) {
        super.init(properties: properties, parentTheme: parentTheme, systemTheme: systemTheme, parentDelegate: parentDelegate)
        
        let properties = properties as! HeadingViewProperties
        
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let fontSize: Double
        switch properties.level {
        case 1: fontSize = 35
        case 2: fontSize = 20
        case 3: fontSize = 15
        default: fatalError()
        }
        label.font = UIFont.systemFont(ofSize: fontSize, weight: properties.font_weight.fontWeight)
        label.textAlignment = properties.alignment.textAlignment
        label.text = properties.text
        label.textColor = systemTheme.textColor
        if properties.auto_wrap {
            label.numberOfLines = 0
        } else {
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
        }
        addSubview(label)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: label.leadingAnchor),
            trailingAnchor.constraint(equalTo: label.trailingAnchor),
            topAnchor.constraint(equalTo: label.topAnchor),
            bottomAnchor.constraint(equalTo: label.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#if DEBUG
import SwiftUI

struct HeadingView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        UIViewPreview {
            let properties = HeadingViewProperties(text: "Test Heading",
                                                   level: 1,
                                                   auto_wrap: true,
                                                   font_weight: .heavy,
                                                   alignment: .left)
            let view = HeadingView(properties: properties, parentTheme: .init(light_theme: .systemBlue, dark_theme: .systemBlue), systemTheme: LivePreviewSystemTheme, parentDelegate: nil)
            return view
        }
        .padding(15)
    }
}
#endif
