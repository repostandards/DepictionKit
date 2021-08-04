//
//  DepictionContainer.swift
//  ExampleApp
//
//  Created by Andromeda on 02/08/2021.
//

import UIKit

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
    private var theme: Theme
    
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
    }
    
    public init(json: [String: Any], presentationController: UIViewController, theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        
        self.presentationController = presentationController
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        loadingIndicator.startAnimating()
        self.loadingIndicator = loadingIndicator
        
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
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data = data,
                  let rawJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                  let json = rawJSON as? [String: Any] else {
                // Error handling here
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
        let depiction: Depiction
        do {
            depiction = try Depiction(json: json, theme: theme)
        } catch {
            NSLog(error.localizedDescription)
            return
        }
        
        for child in depiction.children {
            contentView.addArrangedSubview(child.view)
            child.view.backgroundColor = .clear
            NSLayoutConstraint.activate([
                child.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                child.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
