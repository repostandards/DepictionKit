//
//  PackageView.swift
//  DepictionKit
//
//  Created by Andromeda on 12/09/2021.
//

import UIKit

/**
 Display a package in the same style as the app
 
 `DepictionPackage.banner` will be ignored here, it is not required.
 
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - package: `DepictionPackage`; The package to display
 */
final public class PackageView: UIView, DepictionViewDelegate {
    
    private enum Error: LocalizedError {
        case missing_package
        case delegate_error

        public var errorDescription: String? {
            switch self {
            case .missing_package: return "PackageView missing required argument: package"
            case .delegate_error: return "PackageView was unable to retrieve a package view from the delegate"
            }
        }
    }
    
    private let package: DepictionPackage
    private var packageView: UIView?
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    internal weak var delegate: DepictionContainerDelegate?
    
    init(for input: [String: Any], theme: Theme, delegate: DepictionContainerDelegate?) throws {
        guard let package = input["package"] as? [String: Any] else { throw Error.missing_package }
        do {
            self.package = try DepictionPackage(for: package)
        } catch {
            throw error
        }
        self.theme = theme
        self.delegate = delegate
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        try applyPackageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyPackageView() throws {
        packageView?.removeFromSuperview()
        guard let view = delegate?.packageView(for: package) else { throw Error.missing_package }
        self.packageView = view
        
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func themeDidChange() {
        try? applyPackageView()
    }
    
}
