//
//  ViewController.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit
import DepictionKit
import Evander

class DepictionViewController: UIViewController {

    private var depictionView: DepictionContainer!
    
    public var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        
        depictionView = DepictionContainer(url: url, presentationController: self, theme: configureTheme(), delegate: self)
        
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(depictionView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            depictionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            depictionView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            depictionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            depictionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            depictionView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
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
              dark_mode: traitCollection.userInterfaceStyle == .dark)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Reconfigure the depiction theme
        depictionView.theme = configureTheme()
        navigationController?.navigationBar.tintColor = depictionView.tintColor
    }
    
}

extension DepictionViewController: DepictionDelegate {
    
    func depictionError(error: String) {
        let alert = UIAlertController(title: "Error Parsing Depiction", message: error, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    func image(for url: URL, completion: @escaping ((UIImage?) -> Void)) -> Bool {
        if let image = EvanderNetworking.image(url, cache: true, { refresh, image in
            guard refresh,
                  let image = image else { return }
            completion(image)
        }) {
            completion(image)
        }
        return true
    }
 
    func handleAction(action: DepictionAction) {
        NSLog("[DepictionKit] Action = \(action)")
    }
    
    func packageView(for package: DepictionPackage) -> UIView {
        DepictionPackageView(package: package)
    }
    
    func finishedDepictionLayout() {
        navigationController?.navigationBar.tintColor = depictionView.tintColor
    }

}
