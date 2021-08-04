//
//  NetworkImageView.swift
//  DepictionKit
//
//  Created by Andromeda on 04/08/2021.
//

import UIKit

internal class NetworkImageView: UIImageView {
    
    public let url: URL
    static var shared = [URL: UIImage]()
    
    init(url: URL) {
        self.url = url
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFit
        
        fetchImage()
    }
    
    private func fetchImage() {
        if let cached = Self.shared[url] {
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
            NetworkImageView.shared[url] = image
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
