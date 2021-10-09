//
//  MainViewController.swift
//  ExampleApp
//
//  Created by Andromeda on 02/08/2021.
//

import UIKit
import DepictionKit

struct ExampleDepiction {
    var name: String
    var url: URL
}

class MainViewController: UIViewController {
    
    private let dataSource: [ExampleDepiction] = [
        ExampleDepiction(name: "Aemulo Depiction", url: URL(string: "https://elihwyma.github.io/Aemulo/NativeDepiction.json")!),
        ExampleDepiction(name: "Local Depiction", url: URL(string: "http://192.168.0.22:5000/static/AemuloDepiction.json")!)
    ]
    
    private var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Custom",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(requestCustomLink))
    }
    
    @objc private func requestCustomLink() {
        let alert = UIAlertController(title: "Custom Depiction Link",
                                      message: "Must be a raw link to the JSON",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "URL"
            textField.keyboardType = .URL
        }
        let addAction = UIAlertAction(title: "Load", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
                guard let text = alert.textFields?[0].text,
                      let url = URL(string: text) else { return }
                self.navigationController?.pushViewController(DepictionViewController(url: url), animated: true)
            }
        })
        alert.addAction(addAction)
        let cancelAcction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(cancelAcction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(DepictionViewController(url: dataSource[indexPath.row].url),
                                                 animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "MainViewController.ExampleCell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = dataSource[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
}
