//
//  DepictionDelegate.swift
//  DepictionKit
//
//  Created by Adam Demasi on 4/8/21.
//

import UIKit

public protocol DepictionDelegate: AnyObject {

    /// The depiction is requesting to open the specified URL.
    ///
    /// DepictionKit already supports opening a Safari View Controller instance when a HTTP(S) URL
    /// is activated, and will attempt to open Universal Links in native apps where possible. If you
    /// wish to implement custom handling for certain URL schemes, you may do so by implementing
    /// this method.
    ///
    /// Once you have decided whether custom handling is required for the specified URL, you must
    /// invoke the `completionHandler` with a boolean value indicating whether you have handled this
    /// URL. If you specify `true`, no further action will be taken by DepictionKit. If you specify
    /// `false`, DepictionKit will invoke its standard URL opening implementation. The block must be
    /// invoked from the main queue.
    ///
    /// - parameter url: The URL to be opened.
    /// - parameter completionHandler: A block you are expected to call once you have decided
    /// whether custom handling is required for this URL.
    func openURL(_ url: URL, completionHandler: @escaping (_ handled: Bool) -> Void)
    
    func handleAction(action: DepictionAction)
    
    func depictionError(error: Error)
}

// Default implementations
/// :nodoc:
extension DepictionDelegate {

    /// :nodoc:
    func openURL(_ url: URL, completionHandler: @escaping (_ handled: Bool) -> Void) {
        completionHandler(false)
    }

}
