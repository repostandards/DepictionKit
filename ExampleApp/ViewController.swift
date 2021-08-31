//
//  ViewController.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit
import DepictionKit

class DepictionViewController: UIViewController {

    private var depictionView: DepictionContainer!
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .systemBackground
        
        depictionView = DepictionContainer(url: url, presentationController: self, theme: configureTheme())
        depictionView.delegate = self
        view.addSubview(depictionView)
        NSLayoutConstraint.activate([
            depictionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            depictionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            depictionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            depictionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureTheme() -> Theme {
        Theme(text_color: .label,
              background_color: .systemBackground,
              tint_color: .systemBlue,
              separator_color: .separator,
              dark_mode: true)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Reconfigure the depiction theme
        depictionView.theme = configureTheme()
    }

}

extension DepictionViewController: DepictionDelegate {
    
    func openURL(_ url: URL, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(false)
    }
    
    
    func handleAction(action: String, external: Bool) {
        NSLog("[DepictionKit] Action = \(action), external = \(external)")
    }
    
}
