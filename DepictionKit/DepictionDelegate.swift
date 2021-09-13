//
//  DepictionDelegate.swift
//  DepictionKit
//
//  Created by Adam Demasi on 4/8/21.
//

import UIKit

/**
 Use DepictionDelegate for interacting with the Depictions being displayed
 
 - Author: Amy

 - Version: 1.0
 */
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
    
    /**
    The depiction is requesting the handling of an action
     
    DepictionKit supports multiple types of actions and has support for an app providing its own actions inside a depicton.
    This should be handled in a switch statement.
     
     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - action: The action to be handled by the application. You can learn more about this in `DepictionAction`
     */
    func handleAction(action: DepictionAction)
    
    /**
    An error has occurred when trying to load the depiction.
     
    This is a fault in the JSON provided to the container. It is recommended that you show this error to the user
    so that the repo maintainer can be made aware of the error
     
     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - error: The error from the depiction. Each error has a localizedDescription for understanding it
     */
    func depictionError(error: Error)
    
    /**
    The depiction is trying to display a `PackageView`
     
    You should return a view for the package in the same style as other views in your app. This is usually a UITableViewCell or UICollectionViewCell. `package`
    contains all the information you need for your view. The view should be optimised for display on both iPhone and iPad. It will be pinned to the trailing and leading
    edge of the depiction. You should apply a constant height constraint to your view.
     
    When you change the theme of the Depiction this method will be invoked again for the same package. You must apply the correct background color to the view.
    It is your job to respond to touch on the package view.
     
     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - package: The package that is to be displayed in the view. You can learn more about this in `DepictionPackage`
     */
    func packageView(for package: DepictionPackage) -> UIView
}

// Default implementations
/// :nodoc:
extension DepictionDelegate {

    /// :nodoc:
    func openURL(_ url: URL, completionHandler: @escaping (_ handled: Bool) -> Void) {
        completionHandler(false)
    }

}
