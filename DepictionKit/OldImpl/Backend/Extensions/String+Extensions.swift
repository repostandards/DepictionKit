//
//  String+Extensions.swift
//  String+Extensions
//
//  Created by Andromeda on 01/08/2021.
//

import Foundation

/// :nodoc:
extension String: LocalizedError {
    public var errorDescription: String? { self }
}
