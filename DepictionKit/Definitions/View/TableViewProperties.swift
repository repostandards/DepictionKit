//
//  TableViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

public struct TableViewProperties: ViewProperties, TintOverrideProperty {
    
    let elements: [TableElement]
    
    let tint_override: Color?
    
    public init(elements: [TableElement], tint_override: Color? = nil) {
        self.elements = elements
        self.tint_override = tint_override
    }

}
