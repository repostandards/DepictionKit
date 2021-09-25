//
//  DepictionPackage.swift
//  DepictionKit
//
//  Created by Andromeda on 13/09/2021.
//

import Foundation

/**
 DepictionPackages are shown in `PackageView` and `PackageBannerView`
       
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - icon: `String`; URL for the Package Icon
    - banner: `String`; URL for the Package Banner
    - identifier: `String`; The Package Bundle Identifier
    - name: `String`; The name of the package
    - author: `String`; Author(s) of the package
    - repo_name: `String`; Name of the repo the package is hosted on
    -  repo_link: `String`;  The URI of the repo the package is hosted on
 */
final public class DepictionPackage {
    
    enum Error: LocalizedError {
        case missing_identifier
        case missing_name
        case missing_author
        case missing_repo_name
        case missing_repo_link
        
        public var errorDescription: String? {
            switch self {
            case .missing_identifier: return "DepictionMissing required argument: identifier"
            case .missing_name: return "DepictionMissing required argument: name"
            case .missing_author: return "DepictionMissing required argument: author"
            case .missing_repo_name: return "DepictionMissing required argument: repo_name"
            case .missing_repo_link: return "DepictionMissing required argument: repo_link"
            }
        }
    }
    
    /// :nodoc:
    public var icon: URL?
    /// :nodoc:
    public var banner: URL?
    /// :nodoc:
    public var identifier: String
    /// :nodoc:
    public var name: String
    /// :nodoc:
    public var author: String
    /// :nodoc:
    public var repo_name: String
    /// :nodoc:
    public var repo_link: URL
    
    init(for input: [String: Any]) throws {
        guard let identifier = input["identifier"] as? String else { throw Error.missing_identifier }
        guard let name = input["name"] as? String else { throw Error.missing_identifier }
        guard let author = input["author"] as? String else { throw Error.missing_author }
        guard let repo_name = input["repo_name"] as? String else { throw Error.missing_repo_name }
        guard let _repo_link = input["repo_link"] as? String,
              let repo_link = URL(string: _repo_link) else { throw Error.missing_repo_link }
        
        self.identifier = identifier
        self.name = name
        self.author = author
        self.repo_name = repo_name
        self.repo_link = repo_link
        
        if let _icon = input["icon"] as? String,
           let icon = URL(string: _icon) {
            self.icon = icon
        }
        if let _banner = input["banner"] as? String,
           let banner = URL(string: _banner) {
            self.banner = banner
        }
    }
}
