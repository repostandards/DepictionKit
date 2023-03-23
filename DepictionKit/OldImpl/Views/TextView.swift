//
//  TextView.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit
import WebKit
import SafariServices
import Down

// To re-export the Down error type from DepictionKit.
private typealias DownError = DownErrors

/**
 Display a paragraph of text formatted with Markdown (+HTML)
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - content: `String`; The text to display
    - format: `String? = "markdown"`; Text formatting style to use (Markdown Flavour). Supports `markdown` and `html`
    - tint_override: `Color?`; Tint color override for links and key words. Defaults to none (conforms to global tint if available)
 */
final public class TextView: UIView, DepictionViewDelegate {
    
    private let webView: WKWebView

    private var webViewHeightConstraint: NSLayoutConstraint!
    private var contentSizeObserver: NSKeyValueObservation!

    internal weak var delegate: DepictionContainerDelegate?
    internal var theme: Theme {
        didSet { themeDidChange() }
    }

    private let content: String
    private var tint_override: Color?
    
    private enum Format: String {
        case markdown
        case html
    }
    
    private enum Error: LocalizedError {
        case invalid_content
        case invalid_format
        case markdown_error(downError: DownError)
        
        public var errorDescription: String? {
            switch self {
            case .invalid_content: return "TextView has invalid argument: content"
            case .invalid_format: return "TextView has invalid argument: format"
            case .markdown_error(downError: _): return "TextView failed to render Markdown"
            }
        }
    }
    
    private static let webViewConfiguration: WKWebViewConfiguration = {
        // Configures the web view to restrict all but the primary purpose of this feature.
        // - No network requests are allowed. Resources can only be loaded from data: URLs, or
        //   inline CSS.
        // - Caching and data storage is in-memory only, in a unique data store per web view.
        // - Navigation within the web view is not allowed.
        // - JavaScript can only be executed by code injected by Sileo.
        // Note: The CSP has "allow-scripts", which might seem contradictory, but this is only to
        // allow our own injected JavaScript to execute. The webpage still can’t run its own JS.
        // "allow-popups" ensures only navigation to a new “popup” window is allowed, which we catch
        // and open natively.
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        configuration.ignoresViewportScaleLimits = false
        configuration.dataDetectorTypes = []
        configuration.setValue("default-src data:; style-src data: 'unsafe-inline'; script-src 'none'; child-src 'none'; sandbox allow-scripts allow-popups",
                               forKey: "overrideContentSecurityPolicy")
        if #available(iOS 14, *) {
            configuration.setValue(false, forKey: "loadsSubresources")
            configuration.defaultWebpagePreferences.allowsContentJavaScript = false
        }
        if #available(iOS 15, *) {
            configuration.setValue(Set<String>(), forKey: "allowedNetworkHosts")
        } else if #available(iOS 14, *) {
            configuration.setValue(false, forKey: "loadsFromNetwork")
        }
        return configuration
    }()
    
    init(for input: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
        guard let content = input["content"] as? String else { throw TextView.Error.invalid_content }
        self.delegate = delegate
        let format = Format(rawValue: input["format"] as? String ?? "markdown")
        switch format {
        case .markdown:
            let down = Down(markdownString: content)
            do {
                self.content = try down.toHTML(.default)
            } catch let error as DownErrors {
                throw Error.markdown_error(downError: error)
            }

        case .html:
            self.content = content

        default:
            throw TextView.Error.invalid_format
        }
        
        var tint_override: Color?
        if let _tint_override = input["tint_override"] as? [String: String] {
            do {
                tint_override = try Color(for: _tint_override)
            } catch {
                throw error
            }
        }
        self.tint_override = tint_override
        self.theme = theme
        
        webView = WKWebView(frame: .zero, configuration: Self.webViewConfiguration)

        super.init(frame: .zero)

        backgroundColor = .clear
        webView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.isScrollEnabled = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isOpaque = false
        addSubview(webView)

        webViewHeightConstraint = webView.heightAnchor.constraint(equalToConstant: 0)
        contentSizeObserver = webView.scrollView.observe(\.contentSize, options: .new) { _, change in
            self.webViewHeightDidChange(change.newValue?.height ?? 0)
        }

        NSLayoutConstraint.activate([
            webView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            webView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            webViewHeightConstraint
        ])
        delegate?.waitForWebView()
        loadWebView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadWebView() {
        // TODO: This inset is a placeholder for now
        let marginEdgeInsets = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)

        let htmlString = """
        <!DOCTYPE html>
        <html theme="\(theme.dark_mode ? "dark" : "light")" style="\(cssVariables)">
        <base target="_blank">
        <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
        <style>
        body {
            margin: \(marginEdgeInsets.cssString);
            background: var(--background-color);
            font: -apple-system-body;
            color: var(--label-color);
            -webkit-text-size-adjust: none;
        }
        pre, xmp, plaintext, listing, tt, code, kbd, samp {
            font-family: ui-monospace, Menlo;
        }
        a {
            text-decoration: none;
            color: var(--tint-color);
        }
        p, h1, h2, h3, h4, h5, h6, ul, ol {
            margin: 0 0 16px 0;
        }
        body > *:last-child {
            margin-bottom: 0;
        }
        </style>
        <body>\(content)</body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    private var cssVariables: String {
        // TODO: Come up with values for the placeholders, or remove them. Not all are used by
        // DepictionKit. Some are provided for HTML depictions to take advantage of.
        // TODO: Also try and come up with more that might be useful?
        """
        --tint-color: \(tint_override?.color(for: theme).cssString ?? theme.tint_color.cssString);
        --background-color: \(theme.background_color.cssString);
        --content-background-color: \("#fff");
        --highlight-color: \("#c00");
        --separator-color: \(theme.separator_color.cssString);
        --label-color: \(theme.text_color.cssString);
        """.replacingOccurrences(of: "\n", with: " ")
    }

    private func themeDidChange() {
        if #available(iOS 14, *) {
            // Safer, uses variable injection, but only supported on iOS 14+.
            let injectJS = """
            document.documentElement.setAttribute("style", value);
            """
            webView.callAsyncJavaScript(injectJS,
                                        arguments: [ "value": cssVariables ],
                                        in: nil,
                                        in: .defaultClient,
                                        completionHandler: nil)
        } else {
            // Be careful that escaping may be needed for the old method. Currently we don’t need to
            // escape since we know cssVariables doesn’t have any weird symbols in it.
            let injectJS = """
            document.documentElement.setAttribute("style", "\(cssVariables)");
            """
            webView.evaluateJavaScript(injectJS, completionHandler: nil)
        }
    }

    private func webViewHeightDidChange(_ height: CGFloat) {
        webViewHeightConstraint.constant = height
        // May need to call layoutIsNeeded, idk yet
    }
    
}

/// :nodoc:
extension TextView: WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        previewingViewControllerForElement elementInfo: WKPreviewElementInfo,
                        defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        guard let url = elementInfo.linkURL,
              let scheme = url.scheme else {
            return nil
        }
        if scheme == "http" || scheme == "https" {
            return delegate?.configureSafariViewController(for: url)
        }
        return nil
    }

    public func webView(_ webView: WKWebView,
                        commitPreviewingViewController previewingViewController: UIViewController) {
        if let viewController = previewingViewController as? SFSafariViewController {
            self.delegate?.present(viewController, animated: true)
        }
    }

    @available(iOS 13, *)
    public func webView(_ webView: WKWebView,
                        contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo,
                        completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
        let url = elementInfo.linkURL
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: {
            if let url = url,
               url.scheme == "http" || url.scheme == "https" {
                let viewController = self.delegate?.configureSafariViewController(for: url)
                return viewController
            }
            return nil
        }, actionProvider: { children in
            UIMenu(children: children)
        })
        completionHandler(configuration)
    }

    @available(iOS 13, *)
    public func webView(_ webView: WKWebView,
                        contextMenuForElement elementInfo: WKContextMenuElementInfo,
                        willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        guard let url = elementInfo.linkURL else {
            return
        }
        animator.addAnimations {
            if let viewController = animator.previewViewController as? SFSafariViewController {
                self.delegate?.present(viewController, animated: true)
            } else {
                self.delegate?.handleAction(action: url.absoluteString, external: true)
            }
        }
    }
}

/// :nodoc:
extension TextView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        switch navigationAction.navigationType {
        case .linkActivated, .formSubmitted:
            // User tapped a link inside the web view.
            delegate?.handleAction(action: url.absoluteString, external: false)

        case .other:
            // The navigation type will be .other and URL will be about:blank when loading an
            // HTML string.
            if url.absoluteString == "about:blank" {
                decisionHandler(.allow)
                return
            }

        default: break
        }
        decisionHandler(.cancel)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        delegate?.signalForWebView()
    }
}
