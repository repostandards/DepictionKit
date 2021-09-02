//
//  DepictionActions.swift
//  DepictionKit
//
//  Created by Andromeda on 02/09/2021.
//

import Foundation

/// Enum of possible actions for a depiction action
public enum DepictionAction {
    
    /**
    Handler for the open URL. An example is `https://twitter.com/elihwyma`
     
     - Author: Amy
     
     - Version: 1.0
     
     - Parameters:
        - url: The URL to open
        - external: Whether the link should be opened in a built in web view or an external open should be opened
     
     - Important: This will only register for the URL schemes HTTP and HTTPS
    */
    case openURL(url: URL, external: Bool)
    
    /**
    Handler for the open depiction option. An example is `nd://open-depiction=https://chariz.com/buy/jellyfish/depiction.json`
     
     - Author: Amy
     
     - Version: 1.0
     
     - Parameters:
        - url: The package bundle ID to open
     
     The recommended implementation is opening this in a second view controller with just a depiction view in it
    */
    case openDepiction(url: URL)
    
    /**
    Handler for the open package option. An example is `nd://open-package=com.amywhile.aemulo`
     
     - Author: Amy
     
     - Version: 1.0
     
     - Parameters:
        - url: The package bundle ID to open
    */
    case openPackage(bundle: String)
    
    /**
    Handler for the add repo action. An example is `nd://add-repo=https://repo.chariz.com`
     
     - Author: Amy
     
     - Version: 1.0
     
     - Parameters:
        - url: The repo URL that is to be added
    */
    case addRepo(url: URL)
    
    /**
     This is to be used for any custom action you would like to invoke in your depictions if you would like to add your own custom views. An example action
     is `sileo://open-installed-contents`
     
     - Author: Amy
     
     - Version: 1.0
     
     - Parameters:
        - action: The custom defined action
     
     - Important: This may also be called for invalid actions in a depiction, you must handle invalid actions on your side
    */
    case custom(action: URL)
    
    /**
    Error handler for depiction actions.
     
     - Author: Amy
     
     - Version: 1.0
     
     - Parameters:
        - error: A string describing the error
        - action: The action that resulted in the error
     
     These errors will be called if there is an error when parsing an action, such as an invalid depiction URL for `open-depiction`. It is suggested to show these errors in an alert.
    */
    case actionError(error: String, action: String)
    
    private init(rawAction: String) {
        guard let url = URL(string: rawAction) else {
            self = .actionError(error: "Action not a URL", action: rawAction)
            return
        }
        guard let scheme = url.scheme else {
            self = .actionError(error: "URL has no scheme", action: rawAction)
            return
        }
        if scheme == "https" || scheme == "http" {
            self = .openURL(url: url)
            return
        }
        guard scheme == "nd" else {
            self = .custom(action: url)
            return
        }
        guard let (action, value) = url.hostValue else {
            self = .actionError(error: "Action has invalid action", action: rawAction)
            return
        }
        switch action {
        case "open-depiction":
            guard let url = URL(string: value) else {
                self = .actionError(error: "Action open-depiction has invalid URL", action: rawAction)
                return
            }
            self = .openDepiction(url: url)
            return
        case "open-package":
            self = .openPackage(bundle: value)
            return
        case "add-repo":
            guard let url = URL(string: value) else {
                self = .actionError(error: "Action add-repo has invalid URL", action: rawAction)
                return
            }
            self = .addRepo(url: url)
            return
        default:
            self = .actionError(error: "Unknown Action", action: rawAction)
        }
    }
}
