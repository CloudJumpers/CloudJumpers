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
}

extension PostGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard postGameManager?.fieldNames != nil, let dataRows = postGameManager?.rankings.count else {
            return Int.zero
        }
        return 1 + dataRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LifecycleConstants.rankingCellIdentifier,
            for: indexPath
        )

        guard let manager = postGameManager, let rankingCell = cell as? PostGameRankingCell else {
            return cell
        }

        if indexPath.row == Int.zero, let first = manager.rankings.first {
            rankingCell.setRow(values: first.columnNames)
            rankingCell.unhighlight()
            return rankingCell
        }

        let ranking = manager.rankings[indexPath.row - 1]
        ranking.supportingFields.contains(key: PGKeys.isUserRow) ? rankingCell.highlight() : rankingCell.unhighlight()
        rankingCell.setRow(values: ranking.values)
        return rankingCell
    }
}
