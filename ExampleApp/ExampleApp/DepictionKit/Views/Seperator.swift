//
//  Seperator.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

final public class Seperator: UIView {
    
    private var theme: Theme
    private let seperator = UIView()
    
    init(input: [String: Any], theme: Theme) {
        self.theme = theme
        super.init(frame: .zero)
        
        addSubview(seperator)
        translatesAutoresizingMaskIntoConstraints = false
        seperator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 3),
            seperator.heightAnchor.constraint(equalToConstant: 1.5),
            seperator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.5),
            seperator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.5),
            seperator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        themeReload(nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeReload(_:)),
                                               name: Theme.change,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func themeReload(_ notification: Notification?) {
        if let notification = notification,
           let theme = notification.object as? Theme {
            self.theme = theme
        }
        seperator.backgroundColor = .label
    }
}
