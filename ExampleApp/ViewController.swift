//
//  ViewController.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit
import DepictionKit

class DepictionViewController: UIViewController {
    
    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .white
        let theme = Theme(text_color: .label, background_color: .systemBackground, tint_color: .systemBlue, dark_mode: true)
        
        let depictionView = DepictionContainer(url: url, presentationController: self, theme: theme)
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

}

