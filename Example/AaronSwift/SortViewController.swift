//
//  SortViewController.swift
//  AaronSwift_Example
//
//  Created by AaronYin on 2020/3/5.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import AaronSwift

struct SortModel {
    var level: Int = 0
}

class SortViewController: UIViewController {

    private var dataSource: [String] = [
        "冒泡排序",
        "选择排序"
    ]
    
    private let models: [SortModel] = {
        let levels: [Int] = [9, 3, 7, 8, 2, 1, 5, 4, 6, 0]
        var models: [SortModel] = []
        for level in levels {
            let model = SortModel(level: level)
            models.append(model)
        }
        return models
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Sort Demo"
        view.addSubview(tableView)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    func bubbleSort() {
        let news = Sort.bubbleSort(models) { (v1, v2) -> Bool in
            return v1.level < v2.level
        }
        for new in news {
            print(new.level)
        }
    }
    
    func selectSort() {
        let news = Sort.selectSort(models) { (v1, v2) -> Bool in
            return v1.level < v2.level
        }
        for new in news {
            print(new.level)
        }
    }
    
}

extension SortViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        if indexPath.row == 0 {
            bubbleSort()
        } else if indexPath.row == 1 {
            selectSort()
        }
    }
    
}
