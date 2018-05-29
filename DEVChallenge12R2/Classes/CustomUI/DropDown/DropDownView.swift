//
//  DropDownView.swift
//  DEVChallenge12R2
//
//  Created by Serhii on 5/28/18.
//  Copyright © 2018 Serhii. All rights reserved.
//

import UIKit

class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    let dropdownOptions = [String]()

    var tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.backgroundColor = UIColor.lightGray
        self.backgroundColor = UIColor.lightGray

        tableView.delegate = self
        tableView.dataSource = self
        self.addSubview(tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropdownOptions[indexPath.row]
        cell.backgroundColor = UIColor.lightGray
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
