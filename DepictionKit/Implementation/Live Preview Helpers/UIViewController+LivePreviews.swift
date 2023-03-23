//
//  UIViewController+LivePreviews.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
    
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
        viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable
    func makeUIViewController(context: Context) -> ViewController {
        viewController
    }
}
#endif
