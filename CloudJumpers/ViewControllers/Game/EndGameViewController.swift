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
    @IBOutlet private var score: UILabel!

    private var names: [String] = []
    private var scores: [String] = []
    private var playerScore: String = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTableView.dataSource = self
        scoreTableView.dataSource = self
        score.text = playerScore
        performGameScoreUpdates(score: playerScore)
    }

    func configure(names: [String], scores: [String], playerScore: String) {
        self.names = names
        self.scores = scores
        self.playerScore = playerScore
    }

    private func performGameScoreUpdates(score: String) {
        let highscoreManager = HighscoreManager()

        let auth = AuthService()
        let displayName = auth.getUserDisplayName()

        if let playerId = auth.getUserId() {
            highscoreManager.submitToHighscores(
                userId: playerId,
                userDisplayName: displayName,
                gameScore: score,
                gameMode: .TimeTrial,
                gameSeed: Constants.testLevelName, // TODO: change to prod level name
                callback: fetchNewHighscoresData
            )
        } else {
            fetchNewHighscoresData()
        }
    }

    private func fetchNewHighscoresData() {
        let highscoreManager = HighscoreManager()

        highscoreManager.fetchTopFiveRecords(
            gameMode: .TimeTrial,
            gameSeed: Constants.testLevelName, // TODO: change to prod level name
            callback: onNewHighscoresData
        )
    }

    private func onNewHighscoresData(_ data: [Highscore]) {
        // reloadData should be called from the main thread
        DispatchQueue.main.async {
            self.names = data.map { $0.userDisplayName }
            self.scores = data.map { $0.completionTime }

            self.nameTableView.reloadData()
            self.scoreTableView.reloadData()
        }
    }
}

extension EndGameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        names.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = getCellIdentifier(tableView: tableView)
        let textDisplay = getCellTextDisplay(tableView: tableView, index: indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        guard let endGameCell = cell as? EndGameCell else {
            return cell
        }

        endGameCell.setupEndGameCell()
        endGameCell.displayText(text: textDisplay)

        return cell
    }

    private func getCellIdentifier(tableView: UITableView) -> String {
        switch tableView {
        case nameTableView:
            return EndGameConstants.nameCellIdentifier
        case scoreTableView:
            return EndGameConstants.scoreCellIdentifier
        default:
            return EndGameConstants.emptyString
        }
    }

    private func getCellTextDisplay(tableView: UITableView, index: Int) -> String {
        switch tableView {
        case nameTableView:
            return names[index]
        case scoreTableView:
            return scores[index]
        default:
            return EndGameConstants.emptyString
        }
    }
}
