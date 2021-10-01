//
//  PackageView.swift
//  ExampleApp
//
//  Created by Andromeda on 25/09/2021.
//

import UIKit
import DepictionKit

public class DepictionPackageView: UIView {
    
    public var depictionPackage: DepictionPackage
    
    init(package: DepictionPackage) {
        self.depictionPackage = package
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(imageView)
        addSubview(stackView)
        addSubview(getButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 7.5),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7.5),
            
            stackView.topAnchor.constraint(equalTo: imageView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            
            getButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            getButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            getButton.leadingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 7.5),
            
            heightAnchor.constraint(equalToConstant: 85)
        ])
        
        packageName.text = package.name
        packageDescription.text = package.author
        packageAuthor.text = package.repo_name
        if let icon = package.icon {
            DispatchQueue.global(qos: .default).async { [weak self] in
                if let data = try? Data(contentsOf: icon) {
                    DispatchQueue.main.async {
                        self?.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 70),
            view.widthAnchor.constraint(equalToConstant: 70)
        ])
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private var packageName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private var packageDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private var packageAuthor: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.axis = .vertical
        
        view.addArrangedSubview(packageName)
        view.addArrangedSubview(packageDescription)
        view.addArrangedSubview(packageAuthor)
        return view
    }()
    
    private var getButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .tertiarySystemFill
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 50)
        ])
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15
        button.layer.cornerCurve = .continuous
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
