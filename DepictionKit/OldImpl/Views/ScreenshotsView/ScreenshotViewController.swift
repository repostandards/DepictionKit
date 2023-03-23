//
//  ScreenshotViewController.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import UIKit

final internal class ScreenshotViewController: UIViewController, DepictionViewDelegate {
    
    private var screenshots: [Screenshot]
    private var corner_radius: CGFloat?
    private var height: CGFloat
    private var width: CGFloat
    private var containers: [ScreenshotContainer]
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    
    private let preselectedIndex: Int
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 3
        view.backgroundColor = .clear
        return view
    }()
    
    init(screenshots: [Screenshot], corner_radius: CGFloat, height: CGFloat, width: CGFloat, selectedIndex: Int, theme: Theme, delegate: DepictionContainerDelegate?) {
        self.screenshots = screenshots
        self.corner_radius = corner_radius
        self.height = height
        self.width = width
        self.theme = theme
        self.preselectedIndex = selectedIndex
        
        self.containers = screenshots.map { ScreenshotContainer(screenshot: $0, height: height, width: width, corner_radius: corner_radius, theme: theme, delegate: delegate) }
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        contentView.isLayoutMarginsRelativeArrangement = true
        
        for container in containers {
            contentView.addArrangedSubview(container)
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: contentView.topAnchor),
                container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pop))
        navigationItem.rightBarButtonItem = back
 
        // Needs to be called manually here because it presents later
        themeDidChange()
    }
    
    @objc private func pop() {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        view.backgroundColor = theme.background_color
        navigationController?.navigationBar.tintColor = theme.tint_color
        
        for container in containers {
            container.label.textColor = theme.text_color
        }
        
        guard !layoutOnce else {
            // Not yet finished init
            return
        }
        
        for container in containers {
            container.theme = theme
            if container.screenshot.displayURL != container.image.url {
                container.image.url = container.screenshot.displayURL
                container.image.fetchImage()
            }
        }
    }

    public var layoutOnce = true
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard layoutOnce else { return }
        _ = containers.map { $0.layoutIfNeeded() }
        // Jump to the right index
        jumpToScreenshot(at: preselectedIndex, animated: false)
        layoutOnce = false
    }
    
    private func jumpToScreenshot(at destination: Int, animated: Bool) {
        let spacing = contentView.spacing
        var point = contentView.layoutMargins.left
        for index in 0...destination {
            let view = containers[index]
            let width = view.image.bounds.size.width
            if index == destination {
                point -= 7
            } else {
                point += width + spacing
            }
        }
        scrollView.setContentOffset(CGPoint(x: point, y: 0), animated: animated)
    }
}

extension ScreenshotViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth = scrollView.bounds.width
            - contentView.layoutMargins.left
            - contentView.layoutMargins.right
        let place = scrollView.contentOffset.x / scrollViewWidth
        jumpToScreenshot(at: Int(round(place)), animated: true)
    }
}

fileprivate class ScreenshotContainer: UIView {
    
    internal var label: UILabel
    internal var screenshot: Screenshot
    internal var theme: Theme {
        didSet {
            screenshot.theme = theme
        }
    }
    
    internal var image: NetworkImageView
    internal var height: CGFloat
    internal var width: CGFloat
    internal var corner_radius: CGFloat
    	
    init(screenshot: Screenshot, height: CGFloat, width: CGFloat, corner_radius: CGFloat, theme: Theme, delegate: DepictionContainerDelegate?) {
        self.screenshot = screenshot
        self.height = screenshot.height ?? height
        self.width = screenshot.width ?? width
        self.corner_radius = corner_radius
            
        self.theme = theme
        self.image = NetworkImageView(url: screenshot.url, delegate: delegate)
        image.layer.masksToBounds = true
        image.layer.cornerRadius = corner_radius
        image.backgroundColor = .clear
        
        self.label = UILabel()
        label.text = screenshot.alt_text
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        addSubview(label)
        
        var constraints = [NSLayoutConstraint]()
        constraints += [
            label.heightAnchor.constraint(equalToConstant: 30),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            image.aspectRatioConstraint(height / width),
            image.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            image.bottomAnchor.constraint(equalTo: label.topAnchor, constant: -5),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
