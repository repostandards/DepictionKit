//
//  TableView.swift .swift
//  DepictionKit
//
//  Created by Andromeda on 31/08/2021.
//

import UIKit

internal protocol TableElements {}

/**
 TableItem is for showing primary text and a subtitle. It uses [Style 1](https://developer.apple.com/documentation/uikit/uitableviewcell/cellstyle/value1) of UITableViewCell.
       
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - title: `String`; The primary text to show in the cell
    - text: `String?`; The subtitle text to show
 */
public struct TableItem: TableElements {
    internal var title: String
    internal var text: String?
}

/**
 TableButton is similar to `TableItem` however they have added support for actions and images.
       
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - text: `String`; The primary text to show in the cell
    - icon: `String?`; A URL to the icon to show
    - action: `String`; The action to invoke when pressing the cell
    - external: `Bool? = false`; Should the action open in an external app if possible
    - tint_override: `Color?`;  Override the tint color of the text
 */
public struct TableButton: TableElements {
    internal var text: String
    internal var icon: String?
    internal var action: String
    internal var external: Bool
    internal var tint_override: Color?
}

/**
 ChangelogItem is for creating simple change logs in your depiction.
 
 ![ChangelogItem example Image](./img/ChangelogItemDemo.png)
       
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - changes: `[String]`; An array of changes. Do not add a prefix.
    - timestamp: `String`; When the change was made. The format is ISO8601 GMT0 en_US_POSIX
    - version: `String`; The version of the update
 */
public struct ChangelogItem: TableElements {
    internal var changes: [String]
    internal var timestamp: String
    internal var version: String
}

/**
 Create a table in the Depiction
 - Author: Amy

 - Version: 1.0
 
 - Parameters:
    - elements: `[TableElements]`; Table elements. Supported elements are `TableItem`, `TableButton` and `ChangelogItem`
    - tint_override: `Color?`; Tint color override for links and key words. Defaults to none (conforms to global tint if available)
 */
final public class TableView: UIView, DepictionViewDelegate {
    
    private var cells: [TableElements]
    private var tableView: AutomaticTableView
    
    private enum Error: LocalizedError {
        case invalid_elements
        case invalid_element(element: [String: Any])
    
        public var errorDescription: String? {
            switch self {
            case .invalid_elements: return "TableView is missing required argument: elements"
            case let .invalid_element(element: element): return "TableView has invalid element: \(element)"
            }
        }
    }
    
    internal var theme: Theme {
        didSet { themeDidChange() }
    }
    internal weak var delegate: DepictionContainerDelegate?
    
    private var tintOverride: Color?
    
    init(for properties: [String: Any], theme: Theme) throws {
        guard let elements = properties["elements"] as? [[String: Any]] else { throw Error.invalid_elements }
        self.theme = theme
        if let _color = properties["tint_override"] as? [String: String] {
            do {
                tintOverride = try Color(for: _color)
                self.theme = Theme(from: theme, with: tintOverride!)
            } catch {
                throw error
            }
        }
        var cells = [TableElements]()
        for element in elements {
            guard let name = element["name"] as? String,
                  let properties = element["properties"] as? [String: Any] else { throw Error.invalid_element(element: element) }
            if name == "TableItem" {
                guard let title = properties["title"] as? String else { throw Error.invalid_element(element: element) }
                cells.append(TableItem(title: title, text: properties["text"] as? String))
            } else if name == "TableButton" {
                guard let text = properties["text"] as? String,
                      let action = properties["action"] as? String else { throw Error.invalid_element(element: element) }
                var tintOverride: Color?
                if let _tint_override = properties["tint_override"] as? [String: String] {
                    do {
                        tintOverride = try Color(for: _tint_override)
                    } catch {
                        throw error
                    }
                }
                cells.append(TableButton(text: text,
                                         icon: properties["icon"] as? String,
                                         action: action,
                                         external: properties["external"] as? Bool ?? false,
                                         tint_override: tintOverride))
            } else if name == "ChangelogItem" {
                guard let changes = properties["changes"] as? [String],
                      let timestamp = properties["timestamp"] as? String,
                      let version = properties["version"] as? String else { throw Error.invalid_element(element: element) }
                cells.append(ChangelogItem(changes: changes,
                                           timestamp: timestamp,
                                           version: version))
            }
        }
        self.cells = cells
        self.tableView = AutomaticTableView()
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        if cells.count == 1 {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorColor = theme.separator_color
        }
        backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -5),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func themeDidChange() {
        if let tintOverride = tintOverride {
            theme = Theme(from: theme, with: tintOverride)
        }
        tableView.separatorColor = theme.separator_color
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
}

extension TableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cells[indexPath.row]
        if let tableButton = cell as? TableButton {
            delegate?.handleAction(action: tableButton.action, external: tableButton.external)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        if let tableItem = cell as? TableItem {
            let cell = TableViewCell(style: .value1, reuseIdentifier: "TableView.TableItem")
            cell.textLabel?.text = tableItem.title
            cell.detailTextLabel?.text = tableItem.text
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = theme.text_color
            cell.detailTextLabel?.textColor = theme.text_color
            cell.selectionStyle = .none
            return cell
        } else if let tableButton = cell as? TableButton {
            let cell = TableButtonCell()
            cell.delegate = delegate
            cell.textView.text = tableButton.text
            cell.textView.textColor = {
                if let override = tableButton.tint_override {
                    return theme.dark_mode ? override.dark_mode : override.light_mode
                }
                return theme.tint_color
            }()
            cell.iconURL = URL(string: tableButton.icon ?? "")
            cell.accessoryType = .disclosureIndicator		
            return cell
        } else if let changelogItem = cell as? ChangelogItem {
            return ChangelogItemCell(item: changelogItem, color: theme.text_color)
        }
        return UITableViewCell() // Should be impossible?
    }
    
}
