//
//  PostGameViewController.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation
import UIKit

class PostGameViewController: UIViewController {
    @IBOutlet private var rankingsTableView: UITableView!
    @IBOutlet private var backToLobbiesButton: UIButton!

    var postGameManager: PostGameManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        rankingsTableView.dataSource = self
        navigationItem.hidesBackButton = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postGameManager?.callback = updateRankingData
        postGameManager?.subscribeToRankings()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        postGameManager?.unsubscribeFromRankings()
        postGameManager = nil
    }

    private func updateRankingData() {
        rankingsTableView.reloadData()
    }

    @IBAction private func buttonOnTap() {
        guard
            let viewControllers = navigationController?.viewControllers,
            let lobbiesViewController = viewControllers.first(where: { $0 is LobbyViewController })
        else {
            return
        }

        navigationController?.popToViewController(lobbiesViewController, animated: true)
    }
}

extension PostGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postGameManager?.rankingsTable.count ?? Int.zero
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: PostGameConstants.rankingCellIdentifier,
            for: indexPath
        )

        guard let manager = postGameManager, let rankingCell = cell as? PostGameRankingCell else {
            return cell
        }

        let rowValues = manager.rankingsTable[indexPath.row]
        rankingCell.setRow(values: rowValues)
        return rankingCell
    }
}
