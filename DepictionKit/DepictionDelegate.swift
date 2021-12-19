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
        - error: The error from the depiction.
     */
    func depictionError(error: String)
    
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
    
    /**
    The depiction is requesting an image for a URL
     
     This delegate method is for providing an image for a link. This is designed for using your own caching system. The image should be
     prepared for display before returning it. If you send a nil image, it will assume the network is down and not try again.
     
     Returning false to this method will fallback to DepictionKits network handler.
     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - url: The URL of the image to be displayed
        - completion: Completion handler for the request, this does not have to be on the main thread
     */
    func image(for url: URL, completion: @escaping ((UIImage?) -> Void)) -> Bool
    
    /**
    The depiction has finished laying out the depiction
     - Author: Amy
    
     - Version: 1.0
     */
    func finishedDepictionLayout()
}

// Default implementations
/// :nodoc:
public extension DepictionDelegate {

    /// :nodoc:
    func image(for url: URL, completion: @escaping ((UIImage?) -> Void)) -> Bool {
        false
    }
    
    /// :nodoc:
    func finishedDepictionLayout() {
        
    }

}
