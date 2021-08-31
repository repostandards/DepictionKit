//
//  AutomaticTableView.swift
//  DepictionKit
//
//  Created by Andromeda on 31/08/2021.
//

import UIKit

final class AutomaticTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
