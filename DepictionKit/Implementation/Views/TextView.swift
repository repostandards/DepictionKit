//
//  TextView.swift
//  DepictionKit
//
//  Created by Amy While on 27/11/2022.
//

import UIKit
import WebKit
import SafariServices
import Down

internal class TextView: DepictionView {
    
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
    
    private var cssVariables: String {
        // TODO: Come up with values for the placeholders, or remove them. Not all are used by
        // DepictionKit. Some are provided for HTML depictions to take advantage of.
        // TODO: Also try and come up with more that might be useful?
        """
        --tint-color: \(depictionTintColor.cssString);
        --background-color: \("#fff");
        --content-background-color: \("#fff");
        --highlight-color: \("#c00");
        --separator-color: \(systemTheme.separatorColor);
        --label-color: \(systemTheme.textColor);
        """.replacingOccurrences(of: "\n", with: " ")
    }
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: Self.webViewConfiguration)
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.scrollView.isScrollEnabled = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.isOpaque = false
        return webView
    }()
    
    private let content: String
    
    override init(properties: ViewProperties, parentTheme: Color, systemTheme: NativeDepictionTheme, parentDelegate: DepictionViewDelegate?) {
        let properties = properties as! TextViewProperties
        switch properties.format {
        case .html:
            self.content = properties.content
        case .markdown:
            let down = Down(markdownString: properties.content)
            do {
                self.content = try down.toHTML(.default)
            } catch {
                self.content = "Unable to parse markdown"
            }
        }
        
        super.init(properties: properties, parentTheme: parentTheme, systemTheme: systemTheme, parentDelegate: parentDelegate)
        
        addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leftAnchor.constraint(equalTo: leftAnchor),
            webView.rightAnchor.constraint(equalTo: rightAnchor),
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
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
        <html theme="\(darkMode ? "dark" : "light")" style="\(cssVariables)">
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
    
}

extension TextView: WKUIDelegate {
    public func webView(_ webView: WKWebView,
                        previewingViewControllerForElement elementInfo: WKPreviewElementInfo,
                        defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
        guard let url = elementInfo.linkURL,
              let scheme = url.scheme else {
            return nil
        }
        if scheme == "http" || scheme == "https" {
            // return delegate?.configureSafariViewController(for: url)
        }
        return nil
    }

    public func webView(_ webView: WKWebView,
                        commitPreviewingViewController previewingViewController: UIViewController) {
        if let viewController = previewingViewController as? SFSafariViewController {
            // self.delegate?.present(viewController, animated: true)
        }
    }

    public func webView(_ webView: WKWebView,
                        contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo,
                        completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
        let url = elementInfo.linkURL
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: {
            if let url = url,
               url.scheme == "http" || url.scheme == "https" {
                // let viewController = self.delegate?.configureSafariViewController(for: url)
                // return viewController
            }
            return nil
        }, actionProvider: { children in
            UIMenu(children: children)
        })
        completionHandler(configuration)
    }

    public func webView(_ webView: WKWebView,
                        contextMenuForElement elementInfo: WKContextMenuElementInfo,
                        willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
        guard let url = elementInfo.linkURL else {
            return
        }
        animator.addAnimations {
            if let viewController = animator.previewViewController as? SFSafariViewController {
                // self.delegate?.present(viewController, animated: true)
            } else {
                // self.delegate?.handleAction(action: url.absoluteString, external: true)
            }
        }
    }
}

extension TextView: WKNavigationDelegate {
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        /*
        switch navigationAction.navigationType {
        case .linkActivated, .formSubmitted:
            // User tapped a link inside the web view.
            // delegate?.handleAction(action: url.absoluteString, external: false)

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
         */
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // delegate?.signalForWebView()
    }
}

#if DEBUG
import SwiftUI

struct TextView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        UIViewPreview {
            let properties = TextViewProperties(content: "Test Content", format: .markdown)
            let view = TextView(properties: properties, parentTheme: .init(light_theme: .systemBlue, dark_theme: .systemBlue), systemTheme: LivePreviewSystemTheme, parentDelegate: nil)
            return view
        }
        .padding(15)
    }
}
#endif
