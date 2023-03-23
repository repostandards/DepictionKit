//
//  TableButtonCell.swift
//  DepictionKit
//
//  Created by Andromeda on 02/10/2021.
//

import UIKit

class TableButtonCell: UITableViewCell {
    
    public lazy var iconViewHeight: NSLayoutConstraint = iconView.heightAnchor.constraint(equalToConstant: 0)
    public lazy var iconViewWidth: NSLayoutConstraint = iconView.widthAnchor.constraint(equalToConstant: 0)
    public lazy var iconViewLeading: NSLayoutConstraint = iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
    public lazy var textViewLeading: NSLayoutConstraint = textView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15)
    public weak var delegate: DepictionContainerDelegate?
    
    let minHeight: CGFloat = 44
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
    public var iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    public var textView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var icon: UIImage? {
        didSet {
            iconView.image = icon
            reloadConstraints()
        }
    }
    
    public var iconURL: URL? {
        didSet {
            icon = nil
            guard let iconURL = iconURL else { return }
            if let delegate = delegate {
                delegate.image(for: iconURL) { [weak self] image in
                    self?.icon = image
                }
                return
            }
            if let image = NetworkImageView.shared.object(forKey: iconURL as NSURL) {
                icon = image
                return
            }
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let data = try? Data(contentsOf: iconURL) {
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self?.icon = image
                        NetworkImageView.shared.object(forKey: iconURL as NSURL)
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        contentView.addSubview(iconView)
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            iconViewHeight,
            iconViewWidth,
            iconViewLeading,
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            textView.topAnchor.constraint(equalTo: contentView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            textViewLeading
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadConstraints() {
        if icon == nil {
            iconViewHeight.constant = 0
            iconViewWidth.constant = 0
            iconViewLeading.constant = 0
            textViewLeading.constant = 20
        } else {
            iconViewHeight.constant = 30
            iconViewWidth.constant = 30
            iconViewLeading.constant = 20
            textViewLeading.constant = 7.5
        }
    }
}
