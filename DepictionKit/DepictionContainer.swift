//
//  DepictionContainer.swift
//  ExampleApp
//
//  Created by Andromeda on 02/08/2021.
//

import UIKit
import SafariServices

/**
 Depiction Container is the main view you need to implement to show depictions in your app
 
 It supports multiple methods of providing a depiction to display, support for light and dark mode, custom tint colours
 and multiple delegate methods for interacting with the depiction.
 
 - Author: Amy

 - Version: 1.0
 */
final public class DepictionContainer: UIView {
    
    private enum Error: LocalizedError {
        case invalid_data
        
        public var errorDescription: String? {
            switch self {
            case .invalid_data: return "Data provided cannot be parsed to JSON"
            }
        }
    }
    
    private var depiction: Depiction?
    private weak var presentationController: UIViewController?
    private var layoutInit = false
    
    private weak var delegate: DepictionDelegate?
    
    /**
     The current theme being used by the Depiction. Setting a new theme will automatically reload the depiction, you do not need to create a new container. You can learn more about this in `Theme`
     
     - Author: Amy
    
     - Version: 1.0
    */
    public var theme: Theme {
        didSet { themeDidChange() }
    }
    internal var effectiveTheme: Theme!
    
    private var loadingIndicator: UIActivityIndicatorView?
    
    private var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()
    
    /**
     Create a new DepictionContainer

     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - url: A URL to the depiction JSON. This will be loaded asynchronously
        - presentationController: View Controller used for alerts
        - theme: The initial theme to be used. You can learn more about this in `Theme`
        - delegate: The delegate to use for the depiction. You can learn more about this in `DepictionDelegate`
    */
    public init(url: URL, presentationController: UIViewController, theme: Theme, delegate: DepictionDelegate) {
        self.theme = theme
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        self.theme = theme
        meta()
        
        fetchDepiction(url: url)
        
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        loadingIndicator.startAnimating()
        self.loadingIndicator = loadingIndicator
    }
    
    /**
     Create a new DepictionContainer

     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - json: JSON dictionary of the depiction to be displayed
        - presentationController: View Controller used for alerts
        - theme: The initial theme to be used. You can learn more about this in `Theme`
        - delegate: The delegate to use for the depiction. You can learn more about this in `DepictionDelegate`
    */
    public init(json: [String: Any], presentationController: UIViewController, theme: Theme, delegate: DepictionDelegate) {
        self.theme = theme
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        meta()
        
        layoutDepiction(json: json, theme: theme)
    }
    
    /**
     Create a new DepictionContainer
     
     - Important: This method should be used in conjuction with `setDepiction(dict: [String: Any]`

     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - presentationController: View Controller used for alerts
        - theme: The initial theme to be used. You can learn more about this in `Theme`
        - delegate: The delegate to use for the depiction. You can learn more about this in `DepictionDelegate`
    */
    public init(presentationController: UIViewController, theme: Theme, delegate: DepictionDelegate) {
        self.theme = theme
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        meta()
        
        tintColor = theme.tint_color
        backgroundColor = theme.background_color
        layoutInit = true
    }
    
    /**
     Create a new DepictionContainer

     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - data: JSON Data of the depiction to be displayed
        - presentationController: View Controller used for alerts
        - theme: The initial theme to be used. You can learn more about this in `Theme`
        - delegate: The delegate to use for the depiction. You can learn more about this in `DepictionDelegate`
    */
    public init(data: Data, presentationController: UIViewController, theme: Theme, delegate: DepictionDelegate) throws {
        self.theme = theme
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        meta()
    
        translatesAutoresizingMaskIntoConstraints = false
        guard let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = rawJSON as? [String: Any] else {
            throw DepictionContainer.Error.invalid_data
        }
        layoutDepiction(json: json, theme: theme)
    }
    
    /**
     Set the currently displayed depiction
    
     - Important: This can only be used in conjuction with `init(presentationController: UIViewController, theme: Theme, delegate: DepictionDelegate)`
    
     - Author: Amy
    
     - Version: 1.0
     
     - Parameters:
        - dict: The JSON dictionary to display
    */
    public func setDepiction(dict: [String: Any]) {
        guard layoutInit else {
            fatalError("Set Depiction Cannot Be Used After Init")
        }
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.setDepiction(dict: dict)
            }
            return
        }
        
        if let depiction = depiction {
            for childView in depiction.children {
                childView.view.removeFromSuperview()
            }
        }
        layoutDepiction(json: dict, theme: theme)
    }
    
    private func meta() {
        addSubview(contentView)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchDepiction(url: URL) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                  let json = rawJSON as? [String: Any],
                  let `self` = self else {
                NSLog("[DepictionKit] failed with error \(error)")
                return
            }
            self.layoutDepiction(json: json, theme: self.theme)
        }
        task.resume()
    }
    
    private func layoutDepiction(json: [String: Any], theme: Theme) {
        // Jump to main thread if called from network stack
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.layoutDepiction(json: json, theme: theme)
            }
            return
        }
        loadingIndicator?.removeFromSuperview()
        do {
            depiction = try Depiction(json: json, theme: theme, delegate: self)
        } catch {
            NSLog(error.localizedDescription)
            return
        }

        // Do another config of the theme, so it catches any tint color from the depiction.
        themeDidChange()
        
        for child in depiction!.children {
            contentView.addArrangedSubview(child.view)
            NSLayoutConstraint.activate([
                child.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                child.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }

    private func themeDidChange() {
        if depiction == nil {
            // We’ll be called again when depiction has loaded.
            return
        }

        effectiveTheme = theme
        if let tintColor = depiction?.tint_color?.color(for: theme) {
            effectiveTheme.tint_color = tintColor
        }

        tintColor = effectiveTheme.tint_color
        backgroundColor = theme.background_color

        // Pass the new theme down to all subviews
        for view in contentView.arrangedSubviews {
            if let view = view as? AnyDepictionView {
                view.theme = effectiveTheme
            }
        }
    }
    
    /**
     For getting the current theme of the depiction
    
     DepictionKit supports Depictions setting a custom tint color for light and dark mode appearances. You can learn more about this in `Color`
    
     - Author: Amy
    
     - Version: 1.0
    */
    public var effectiveTintColor: UIColor {
        depiction?.tint_color?.color(for: theme) ?? theme.tint_color
    }
}

extension DepictionContainer: DepictionContainerDelegate {

    internal func openURL(_ url: URL, inAppIfPossible inApp: Bool) {
        let handler = { (handled: Bool) in
            if handled {
                // Do nothing, the delegate has handled this URL.
                return
            }

            // Try opening as universal link first
            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { success in
                if success {
                    // Cool! We’re done.
                    return
                }

                if inApp && (url.scheme == "http" || url.scheme == "https") {
                    // Push Safari View Controller.
                    let viewController = self.configureSafariViewController(for: url)
                    self.presentationController?.present(viewController, animated: true, completion: nil)
                } else {
                    // Attempt a traditional URL open.
                    // TODO: Report failure to the user somehow?
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }

        if let delegate = delegate {
            delegate.openURL(url, completionHandler: handler)
        } else {
            handler(false)
        }
    }

    func configureSafariViewController(for url: URL) -> SFSafariViewController {
        assert(url.scheme == "http" || url.scheme == "https")

        // Needed because Safari team still haven’t figured out how to not make the bar glitch on
        // scroll when displayed as a modal sheet.
        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = false

        let viewController = SFSafariViewController(url: url, configuration: configuration)
        viewController.modalPresentationStyle = .formSheet
        viewController.preferredControlTintColor = theme.tint_color
        return viewController
    }

    func present(_ viewController: UIViewController, animated: Bool) {
        presentationController?.present(viewController, animated: animated, completion: nil)
    }
    
    func handleAction(action: String, external: Bool) {
        delegate?.handleAction(action: DepictionAction(rawAction: action, external: external))
    }
    
    func packageView(for package: DepictionPackage) -> UIView? {
        delegate?.packageView(for: package)
    }

}
