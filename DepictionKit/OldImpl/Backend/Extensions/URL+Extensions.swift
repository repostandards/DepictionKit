//
//  URL+Extensions.swift
//  DepictionKit
//
//  Created by Andromeda on 02/09/2021.
//

import Foundation

/// :nodoc:
extension URL {
    
    var queryDict: [String: String]? {
        guard let queryString = self.query else { return nil }
        return queryString.components(separatedBy: "&").map({
            $0.components(separatedBy: "=")
        }).reduce(into: [String: String]()) { dict, pair in
            if pair.count == 2 {
                dict[pair[0]] = pair[1]
            }
        }
    }
    
    var hostDict: [String: String]? {
        guard let hostString = self.host else { return nil }
        return hostString.components(separatedBy: "&").map({
            $0.components(separatedBy: "=")
        }).reduce(into: [String: String]()) { dict, pair in
            if pair.count == 2 {
                dict[pair[0]] = pair[1]
            }
        }
    }
    
    var hostValue: (String, String)? {
        let content = absoluteString.replacingOccurrences(of: "\(scheme ?? "")://", with: "")
        var values = content.components(separatedBy: "=")
        guard values.count >= 2 else { return nil }
        let action = values.removeFirst()
        let value = values.joined()
        return (action, value)
    }
    
}
