//
//  DepictionContainer.swift
//  ExampleApp
//
//  Created by Andromeda on 02/08/2021.
//

import UIKit
import SafariServices

final public class DepictionContainer: UIView {
    
    enum Error: LocalizedError {
        case invalid_data
        
        public var errorDescription: String? {
            switch self {
            case .invalid_data: return "Data provided cannot be parsed to JSON"
            }
        }
    }
    
    private var depiction: Depiction?
    private weak var presentationController: UIViewController?

    public weak var delegate: DepictionDelegate?
    public var theme: Theme {
        didSet { themeDidChange() }
    }
    internal var effectiveTheme: Theme!
    
    private var loadingIndicator: UIActivityIndicatorView?
    
    public var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    public var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()
    
    public init(url: URL, loginToken: String? = nil, presentationController: UIViewController, theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        self.theme = theme
        
        meta()
        fetchDepiction(url: url, loginToken: loginToken, theme: theme)
        
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
    
    public init(json: [String: Any], presentationController: UIViewController, theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        
        meta()
        layoutDepiction(json: json, theme: theme)
    }
    
    public init(data: Data, presentationController: UIViewController, theme: Theme) throws {
        self.theme = theme
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        
        meta()
        guard let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []),
              let json = rawJSON as? [String: Any] else {
            throw DepictionContainer.Error.invalid_data
        }
        layoutDepiction(json: json, theme: theme)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func meta() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func fetchDepiction(url: URL, loginToken: String? = nil, theme: Theme) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,
                  let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                  let json = rawJSON as? [String: Any] else {
                NSLog("[DepictionKit] failed with error \(error)")
                return
            }
            self?.layoutDepiction(json: json, theme: theme)
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

}
