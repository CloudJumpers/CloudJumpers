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
    }

    func configure(names: [String], scores: [String], playerScore: String) {
        self.names = names
        self.scores = scores
        self.playerScore = playerScore
        performGameScoreUpdates(score: playerScore)
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
