//
//  ChangelogItemCell.swift
//  DepictionKit
//
//  Created by Andromeda on 02/10/2021.
//

import UIKit

class ChangelogItemCell: UITableViewCell {
    
    static let iso8601DateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
    
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "HH:mm d MMM y"
        return formatter
    }()
    
    public var versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    public var changelogList: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isScrollEnabled = false
        view.isUserInteractionEnabled = false
        view.isEditable = false
        view.font = UIFont.systemFont(ofSize: 14)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //view.adjustsFontForContentSizeCategory = true
        return view
    }()
    
    public var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(item: ChangelogItem, color: UIColor) {
        super.init(style: .default, reuseIdentifier: nil)
        
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(versionLabel)
        contentView.addSubview(changelogList)
        //contentView.addSubview(dateLabel)
        changelogList.backgroundColor = .red
        versionLabel.text = item.version
        NSLayoutConstraint.activate([
            versionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            versionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            versionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            
            changelogList.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 5),
            changelogList.leadingAnchor.constraint(equalTo: versionLabel.leadingAnchor),
            changelogList.trailingAnchor.constraint(equalTo: versionLabel.trailingAnchor),
            changelogList.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            /*
            changelogList.bottomAnchor.constraint(equalTo: versionLabel.topAnchor, constant: 0),
            
            dateLabel.leadingAnchor.constraint(equalTo: versionLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: versionLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            */
        ])
        /*
        changelogList.backgroundColor = .red
        versionLabel.text = item.version
        if let date = Self.iso8601DateFormatter.date(from: item.timestamp) {
            dateLabel.text = Self.displayFormatter.string(from: date)
            NSLog("\(dateLabel.text)")
        }
        
        var attributes = [NSAttributedString.Key: Any]()
        let paragraphStyle = NSMutableParagraphStyle()
        let bullet = "\u{2022} "
        paragraphStyle.headIndent = (bullet as NSString).size(withAttributes: attributes).width
        attributes[.paragraphStyle] = paragraphStyle
        attributes[.foregroundColor] = color
        changelogList.attributedText = NSAttributedString(string: item.changes.joined(separator: "\n"),
                                                          attributes: attributes)
        NSLog("Test = \(changelogList.attributedText) \(changelogList.bounds) \(changelogList.frame)")
        dateLabel.textColor = color
        versionLabel.textColor = color
        */
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
