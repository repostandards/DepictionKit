//
//  ScreenshotsView.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import UIKit

/**
 Create an array of media
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - screenshots: `[Screenshot]`; Screenshot contents.
    - corner_radius: `Int? = 4`; Image corner radius.
 */
final public class ScreenshotsView: UIView, DepictionViewDelegate {
    
    private enum Error: LocalizedError {
        case missing_screenshots
        case empty_screenshots
        case invalid_content_size
        
        public var errorDescription: String? {
            switch self {
            case .missing_screenshots: return "ScreenshotsView missing required argument: screenshots"
            case .empty_screenshots: return "ScreenshotsView requires at least one screenshot"
            case .invalid_content_size: return "Screenshot has invalid content size"
            }
        }
    }
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        return scrollView
    }()
    
    private var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 5
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let screenshots: [Screenshot]
    private let height: CGFloat
    private let width: CGFloat
    private let cornerRadius: CGFloat
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    internal weak var delegate: DepictionContainerDelegate?
    
    init(for input: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
        guard let screenshots = input["screenshots"] as? [[String: Any]] else { throw Error.missing_screenshots }
        let content_size = input["content_size"] as? [String: Int]
        guard !screenshots.isEmpty else { throw Error.empty_screenshots }
        do {
            self.screenshots = try screenshots.map { try Screenshot(for: $0, theme: theme, content_size: content_size) }
        } catch {
            throw error
        }
        self.cornerRadius = CGFloat(input["corner_radius"] as? Int ?? 4)
        self.theme = theme
        
        guard let content_size = input["content_size"] as? [String: Int],
              let width = content_size["width"],
              let height = content_size["height"] else { throw Error.invalid_content_size }
        self.height = CGFloat(height)
        self.width = CGFloat(width)
        super.init(frame: .zero)
        
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
            
            contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            
            heightAnchor.constraint(equalToConstant: 250)
        ])
        
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        contentView.isLayoutMarginsRelativeArrangement = true
        
        var constraints = [NSLayoutConstraint]()
        for (index, screenshot) in self.screenshots.enumerated() {
            let imageView = NetworkImageView(url: screenshot.url, delegate: delegate)
            imageView.backgroundColor = .clear
            
            let height = screenshot.height ?? self.height
            let width = screenshot.width ?? self.width
            constraints.append(imageView.aspectRatioConstraint(height / width))
            constraints.append(imageView.topAnchor.constraint(lessThanOrEqualTo: contentView.topAnchor, constant: 5))
            constraints.append(imageView.topAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5))
            let lesserTop = imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
            lesserTop.priority = UILayoutPriority(750)
            constraints.append(lesserTop)
            let lesserBottom = imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            lesserBottom.priority = UILayoutPriority(750)
            constraints.append(lesserBottom)
            
            imageView.accessibilityLabel = screenshot.alt_text
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = cornerRadius
            imageView.tag = index
            imageView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(screenshotTapped(_:)))
            imageView.addGestureRecognizer(tapGesture)
            contentView.addArrangedSubview(imageView)
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func screenshotTapped(_ sender: UIGestureRecognizer) {
        guard let view = sender.view else { return }
        let screenshotsView = ScreenshotViewController(screenshots: screenshots,
                                                       corner_radius: cornerRadius,
                                                       height: height,
                                                       width: width,
                                                       selectedIndex: view.tag,
                                                       theme: theme,
                                                       delegate: delegate)
        screenshotsView.view.tintColor = theme.tint_color
        let navController = UINavigationController(rootViewController: screenshotsView)
        delegate?.present(navController, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        backgroundColor = theme.background_color
        
        guard contentView.subviews.count == screenshots.count else {
            // We have not finished init
            return
        }
        for (index, screenshot) in screenshots.enumerated() {
            guard let imageView = contentView.subviews[index] as? NetworkImageView else { continue }
            let url = imageView.url
            screenshot.theme = theme
            if screenshot.displayURL != url {
                imageView.url = screenshot.displayURL
                imageView.fetchImage()
            }
        }
    }
}
