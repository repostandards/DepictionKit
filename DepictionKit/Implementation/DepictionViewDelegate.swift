//
//  DepictionViewDelegate.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import UIKit

protocol DepictionViewDelegate: AnyObject {
    
    func depictionView(_ depictionView: DepictionView, requesting image: URL, completion: @escaping (UIImage) -> Void)
    
}
