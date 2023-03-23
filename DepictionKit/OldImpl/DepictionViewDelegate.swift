//
//  DepictionViewDelegate.swift
//  DepictionKit
//
//  Created by Adam Demasi on 4/8/21.
//

import UIKit

internal protocol DepictionViewDelegate: AnyObject {

    var delegate: DepictionContainerDelegate? { get set }
    var theme: Theme { get set }

}

// Default implementations of protocol optional requirements
// swiftlint:disable unused_setter_value
internal extension DepictionViewDelegate {

    var delegate: DepictionContainerDelegate? {
        get { nil }
        set {}
    }

    var theme: Theme {
        get { fatalError("The Theme Getter has not been implemented") }
        set {}
    }

}
// swiftlint:enable unused_setter_value
