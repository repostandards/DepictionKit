//
//  PackageBannerList.swift
//  DepictionKit
//
//  Created by Somica on 09/02/2022.
//

import UIKit

class PackageBannerList: UIView, DepictionViewDelegate {
    
    private enum Error: LocalizedError {
        case missing_packages
        case no_banner

        public var errorDescription: String? {
            switch self {
            case .missing_packages: return "PackageBannerList missing required argument: packages"
            case .no_banner: return "Package does not have required property, banner"
            }
        }
    }
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    internal weak var delegate: DepictionContainerDelegate?
    private let packages: [DepictionPackage]
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private var contentView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.spacing = 15
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        view.isLayoutMarginsRelativeArrangement = true
        return view
    }()
    
    init(for input: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
        guard let inputPackages = input["packages"] as? [[String: Any]] else { throw Error.missing_packages }
        let packages: [DepictionPackage]
        do {
            packages = try inputPackages.map { try DepictionPackage(for: $0) }
            try packages.forEach { if $0.banner == nil { throw Error.no_banner } }
        } catch {
            throw error
        }
        self.packages = packages
        self.theme = theme
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
            
            contentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            
            heightAnchor.constraint(equalToConstant: 158)
        ])
        
        for (index, package) in packages.enumerated() {
            let view = PackageBannerView(url: package.banner!, name: package.name, delegate: delegate)
            view.imageView.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped(_:)))
            view.imageView.addGestureRecognizer(tapGesture)
            contentView.addArrangedSubview(view)
        }
    }
    
    @objc private func bannerTapped(_ sender: UIGestureRecognizer) {
        guard let view = sender.view else { return }
        delegate?.handlePressed(package: packages[view.tag])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        let views = contentView.subviews.compactMap { $0 as? PackageBannerView }
        views.forEach { $0.set(theme: theme) }
    }
    
    private class PackageBannerView: UIView {
        
        let label: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 27).isActive = true
            label.textAlignment = .left
            return label
        }()
        
        public lazy var imageView: NetworkImageView = {
            let view = NetworkImageView(url: url, delegate: delegate)
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = true
            return view
        }()
        
        let url: URL
        private weak var delegate: DepictionContainerDelegate?
        
        init(url: URL, name: String, delegate: DepictionContainerDelegate?) {
            self.url = url
            self.delegate = delegate
            super.init(frame: .zero)
            addSubview(imageView)
            addSubview(label)
            translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: 148),
                widthAnchor.constraint(equalToConstant: 263),
                
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.5),
                label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.5),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.5)
            ])
            
            layer.masksToBounds = true
            layer.cornerRadius = 10
            label.text = name
            accessibilityHint = name
            isUserInteractionEnabled = true
        }
        
        public func set(theme: Theme) {
            label.textColor = theme.text_color
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
}

