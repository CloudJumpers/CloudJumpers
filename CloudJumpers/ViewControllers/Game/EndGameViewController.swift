//
//  EndGameViewController.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/3/22.
//

import Foundation
import UIKit

class EndGameViewController: UIViewController {
    @IBOutlet private var nameTableView: UITableView!
    @IBOutlet private var scoreTableView: UITableView!

    var names = ["Hello", "my", "name", "is", "John"]
    var scores = ["10", "200", "500", "1000", "20000"]

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTableView.dataSource = self
        scoreTableView.dataSource = self
    }
}

extension EndGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        switch tableView {
        case nameTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
            cell.textLabel?.text = names[indexPath.row]
        case scoreTableView:
            tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)
            cell.textLabel?.text = scores[indexPath.row]
        default:
            break
        }

        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.black.cgColor

        return cell
    }
}
