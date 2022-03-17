//
//  EndGameViewController.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/3/22.
//

import Foundation
import UIKit

class EndGameViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private var names = ["Hello", "my", "name", "is", "John"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension EndGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "highScore", for: indexPath)

        cell.textLabel?.text = names[indexPath.row]
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.black.cgColor

        return cell
    }
}
