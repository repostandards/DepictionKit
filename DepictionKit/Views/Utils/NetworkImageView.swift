//
//  NetworkImageView.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import UIKit

internal class NetworkImageView: UIImageView {
    
    public var url: URL
    static var shared = NSCache<NSURL, UIImage>()
    public weak var delegate: DepictionContainerDelegate?
    
    init(url: URL, delegate: DepictionContainerDelegate? ) {
        self.url = url
        self.delegate = delegate
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        
        fetchImage()
    }
    
    public func fetchImage() {
        if let delegate = delegate {
            let url = url
            delegate.image(for: url) { [weak self] image in
                guard url == self?.url else { return }
                self?.image = image
            }
            return
        }
        if let cached = Self.shared.object(forKey: url as NSURL) {
            self.image = cached
            return
        }
        let url = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data,
                  var image = UIImage(data: data),
                  let strong = self,
                  url == strong.url else { return }
            image = image.prepareForDisplay()
            NetworkImageView.shared.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                strong.image = image
            }
        }
        task.resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
