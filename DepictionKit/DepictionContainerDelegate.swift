//
//  DepictionContainerDelegate.swift
//  DepictionKit
//
//  Created by Adam Demasi on 4/8/21.
//

import UIKit
import SafariServices

internal protocol DepictionContainerDelegate: AnyObject {

    func openURL(_ url: URL, inAppIfPossible inApp: Bool)
    func configureSafariViewController(for url: URL) -> SFSafariViewController
    func present(_ viewController: UIViewController, animated: Bool)
    func handleAction(action: String, external: Bool)
    func packageView(for package: DepictionPackage) -> UIView?

}
