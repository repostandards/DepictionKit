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
internal extension DepictionViewDelegate {

    var delegate: DepictionContainerDelegate? {
        get { nil }
        set {}
    }

    var theme: Theme {
        get { fatalError() }
        set {}
    }

}
