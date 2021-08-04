//
//  UIEdgeInsets+Extensions.swift
//  DepictionKit
//
//  Created by Adam Demasi on 4/8/21.
//

import UIKit

extension UIEdgeInsets {
    internal var cssString: String {
        String(format: "%.2fpx %.2fpx %.2fpx %.2fpx", top, right, bottom, left)
    }
}
