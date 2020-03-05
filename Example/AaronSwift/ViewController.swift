//
//  ViewController.swift
//  AaronSwift
//
//  Created by AaronYin0514 on 02/25/2020.
//  Copyright (c) 2020 AaronYin0514. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var dataSource: [String] = [
        "Sort"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo"
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let string = dataSource[indexPath.row]
        if string == "Sort" {
            let vc = SortViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

