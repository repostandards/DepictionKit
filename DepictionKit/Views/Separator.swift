//
//  Seperator.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

final public class Separator: UIView, DepictionViewDelegate {

    internal var theme: Theme {
        didSet { themeDidChange() }
    }

    private let separator = UIView()
    
    init(for input: [String: Any], theme: Theme) throws {
        self.theme = theme
        super.init(frame: .zero)
        
        addSubview(separator)
        translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        var direction: Direction = .horizontal
        if let _direction = input["direction"] as? String {
            do {
                direction = try Direction(input: _direction)
            } catch {
                throw error
            }
        }
        
        if direction == .horizontal {
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: 3),
                separator.heightAnchor.constraint(equalToConstant: 1.5),
                separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2.5),
                separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2.5),
                separator.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: 3),
                separator.topAnchor.constraint(equalTo: topAnchor, constant: 2.5),
                separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.5),
                separator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }

        themeDidChange()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        separator.backgroundColor = theme.text_color
        backgroundColor = theme.background_color
    }
}
