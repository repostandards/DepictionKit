//
//  TabView.swift
//  DepictionKit
//
//  Created by Amy While on 07/03/2022.
//

import UIKit

final public class TabView: UIView, DepictionViewDelegate {
    
    private enum Error: LocalizedError {
        case missing_tabs
        
        public var errorDescription: String? {
            switch self {
            case .missing_tabs: return "TabView missing required argument: tabs"
            }
        }
    }
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    internal weak var delegate: DepictionContainerDelegate?
    private var tabs: [DepictionTab] = []
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        // scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    private var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.backgroundColor = .clear
        view.spacing = 15
        return view
    }()
    
    init(for input: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
        guard let _tabs = input["tabs"] as? [[String: Any]] else { throw Error.missing_tabs }
        
        self.theme = theme
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        for tab in _tabs {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addArrangedSubview(view)
            view.backgroundColor = .randomColor()
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalTo: widthAnchor)
            ])
            tabs.append(try DepictionTab(tab, theme: theme, delegate: delegate, in: view))
        }
        NSLog("[Aemulo] Tabs = \(tabs.map { $0.children })")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        tabs.forEach { $0.themeDidChange(theme) }
    }
}

extension TabView: UIScrollViewDelegate {
    
    /*
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.bounds.width
        let pageFraction = scrollView.contentOffset.x/pageWidth
            
        let offset = Int((round(pageFraction))) * Int(pageWidth)
        
        UIView.animate(withDuration: 0.33, animations: { [weak self] in
          self?.scrollView.contentOffset.x = CGFloat(offset)
        })
    }
    */
    
}

extension UIColor {
    class func randomColor(randomAlpha: Bool = false) -> UIColor {
        let redValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let greenValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let blueValue = CGFloat(arc4random_uniform(255)) / 255.0;
        let alphaValue = randomAlpha ? CGFloat(arc4random_uniform(255)) / 255.0 : 1;

        return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alphaValue)
    }
}
