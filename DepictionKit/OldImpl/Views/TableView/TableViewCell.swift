//
//  TableViewCell.swift
//  DepictionKit
//
//  Created by Andromeda on 02/10/2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    let minHeight: CGFloat = 44
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        return CGSize(width: size.width, height: max(size.height, minHeight))
    }
    
}
