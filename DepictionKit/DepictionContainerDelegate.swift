//
//  DepictionContainerDelegate.swift
//  DepictionKit
//
//  Created by Adam Demasi on 4/8/21.
//

import UIKit
import SafariServices

internal protocol DepictionContainerDelegate: AnyObject {

    func configureSafariViewController(for url: URL) -> SFSafariViewController
    func present(_ viewController: UIViewController, animated: Bool)
    func handleAction(action: String, external: Bool)
    func packageView(for package: DepictionPackage) -> UIView?
    func image(for url: URL, completion: @escaping ((UIImage) -> ()))
    
    func waitForWebView()
    func signalForWebView()
}
