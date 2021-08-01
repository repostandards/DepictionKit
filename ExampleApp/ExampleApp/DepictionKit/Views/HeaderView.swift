//
//  HeaderView.swift
//  HeaderView
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit

/// Display a string of text as a heading
final public class HeaderView: UIView {
    
    private let label = UILabel()
    private var text_color: Color?
    private var theme: Theme
    
    enum Error: LocalizedError {
        case invalid_text(view: [String: Any])
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_text(view): return "\(view) is missing required argument: text"
            }
        }
    }
    
    init(input: [String: Any], theme: Theme) throws {
        guard let text = input["text"] as? String else { throw HeaderView.Error.invalid_text(view: input) }
        self.theme = theme
        super.init(frame: .zero)
        
        addSubview(label)
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
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
        label.font = UIFont.systemFont(ofSize: sizing_level == 1 ? 35 : 20, weight: weight)
        
        var alignment: NSTextAlignment = .left
        if let text_color = input["alignment"] as? String {
            do {
                alignment = try FontAlignment.alignment(for: text_color)
            } catch {
                throw error
            }
        }
        label.textAlignment = alignment
        
        themeReload(nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(themeReload(_:)),
                                               name: Theme.change,
                                               object: nil)
    }
    
    @objc private func themeReload(_ notification: Notification?) {
        if let notification = notification,
           let theme = notification.object as? Theme {
            self.theme = theme
        }
        
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

/*
 HeadingView: {
         /**
          * The text to display
          * Required
          */
         text: string

         /**
          * Sizing level. Similar to HTML's '<h1>' and '<h2>' or Markdown's # or ##.
          * Default: 1 (h1)
          */
         level?: 1 | 2
         
         /**
          * Auto Wrap. If enabled headings will automatically wrap to multiple lines. If false the text will shrink to fit
          * Default: false
          */
         auto_wrap?: boolean

         /**
          * Text color for the heading view
          * Default: System theme colors
          */
         text_color?: Color

         /**
          * Font weight for the heading view
          * Default: semibold
          */
         font_weight?: FontWeight

         /**
          * Text alignment for the heading view
          * Default: start
          */
         alignment?: Alignment
     }

 */
