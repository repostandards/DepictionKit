//
//  ViewController.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        let theme = Theme(text_color: .label, background_color: .systemBackground, tint_color: .systemBlue, dark_mode: true)
        
        let url = URL(string: "https://hastebin.com/raw/ogigisicez")!
        let depictionView = DepictionContainer(url: url, presentationController: self, theme: theme)
        view.addSubview(depictionView)
        NSLayoutConstraint.activate([
            depictionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            depictionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            depictionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            depictionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

}

