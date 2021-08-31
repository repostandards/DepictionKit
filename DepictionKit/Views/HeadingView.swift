//
//  HeaderView.swift
//  HeaderView
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/// Display a string of text as a heading
final public class HeadingView: UIView, DepictionViewDelegate {
    
    private let label = UILabel()
    private var text_color: Color?

    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    
    enum Error: LocalizedError {
        case invalid_text(view: [String: Any])
        case invalid_size(size: Int)
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_text(view): return "\(view) is missing required argument: text"
            case let .invalid_size(size: size): return "HeadingView has invalid sizing_level: \(size)"
            }
        }
    }
    
    init(for input: [String: Any], theme: Theme) throws {
        guard let text = input["text"] as? String else { throw Error.invalid_text(view: input) }
        self.theme = theme
        super.init(frame: .zero)
        
        addSubview(label)
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.accessibilityLabel = text
        label.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
        let auto_wrap = input["auto_wrap"] as? Bool ?? true
        if auto_wrap {
            label.numberOfLines = 0
        } else {
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
        }
        
        if let text_color = input["text_color"] {
            do {
                self.text_color = try Color.init(for: text_color)
            } catch {
                throw error
            }
        }
        
        let sizing_level = input["level"] as? Int ?? 1
        var weight: UIFont.Weight = .semibold
        if let font_weight = input["font_weight"] as? String {
            do {
                weight = try FontWeight.weight(for: font_weight)
            } catch {
                throw error
            }
        }
        let font: UIFont
        switch sizing_level {
        case 1: font = UIFont.systemFont(ofSize: 35, weight: weight)
        case 2: font = UIFont.systemFont(ofSize: 20, weight: weight)
        case 3: font = UIFont.systemFont(ofSize: 15, weight: weight)
        default: throw Error.invalid_size(size: sizing_level)
        }
        label.font = font
        
        var alignment: NSTextAlignment = .left
        if let text_color = input["alignment"] as? String {
            do {
                alignment = try FontAlignment.alignment(for: text_color)
            } catch {
                throw error
            }
        }
        label.textAlignment = alignment
        
        themeDidChange()
    }
    
    private func themeDidChange() {
        backgroundColor = theme.background_color
        if let text_color = text_color {
            label.textColor = theme.dark_mode ? text_color.dark_mode : text_color.light_mode
        } else {
            label.textColor = theme.text_color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
