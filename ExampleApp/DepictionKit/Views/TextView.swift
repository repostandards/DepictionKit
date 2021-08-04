//
//  TextView.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit
import WebKit
import SafariServices

final public class TextView: UIView {
    
    private var webView: WKWebView?
    
    private var theme: Theme
    private var tint_override: Color?
    
    enum Format {
        case markdown
        case html
    }
    
    enum Error: LocalizedError {
        case invalid_content
        case invalid_format
        
        public var errorDescription: String? {
            switch self {
            case .invalid_content: return "TextView has invalid arugment: content"
            case .invalid_format: return "TextView has invalid arugment: format"
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
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .nonPersistent()
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        configuration.ignoresViewportScaleLimits = false
        configuration.dataDetectorTypes = []
        configuration._overrideContentSecurityPolicy = "default-src data:; style-src data: 'unsafe-inline'; script-src 'none'; child-src 'none'; sandbox allow-scripts"
        if #available(iOS 14, *) {
            configuration._loadsSubresources = false
            configuration.defaultWebpagePreferences.allowsContentJavaScript = false
        }
        if #available(iOS 15, *) {
            configuration._allowedNetworkHosts = Set()
        } else if #available(iOS 14, *) {
            configuration._loadsFromNetwork = false
        }
        return configuration
    }()
    
    init(input: [String: Any], theme: Theme) throws {
        guard let content = input["content"] as? String else { throw TextView.Error.invalid_content }
        var format: Format
        switch input["format"] as? String {
        case "markdown": format = .markdown
        case "html": format = .html
        default: throw TextView.Error.invalid_content
        }
        
        var tint_override: Color?
        if let _tint_override = input["tint_override"] {
            do {
                tint_override = try Color.init(for: _tint_override)
            } catch {
                throw error
            }
        }
        self.tint_override = tint_override
        self.theme = theme
        
        webView = WKWebView(frame: .zero, configuration: Self.webViewConfiguration)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/*
 /**
      * Display a paragraph of text formatted with Markdown (+HTML)
      */
     TextView: {
         /**
          * The text to display.
          * Required
          */
         content: string

         /**
          * Text formatting style to use (Markdown Flavour).
          * @default 'markdown'
          */
         format?: 'markdown' | 'html'

         /**
          * Tint color override for links and key words
          * Defaults to none (conforms to global tint if available)
          */
         tint_override?: Color
     }
 */
