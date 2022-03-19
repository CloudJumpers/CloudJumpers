//
//  GameEndState.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import Foundation

class TimeTrialGameEndState {
    struct Score {
        let ranking: Int
        let name: String
        let score: Double
    }

    var scores = [Score]()

    init(playerEndTime: Double) {
        scores.append(Score(ranking: 0, name: "You", score: playerEndTime))
        fetchHighScorer()
    }

    func fetchHighScorer() {
        for i in 1...5 {
            scores.append(Score(ranking: i, name: "Friend", score: Double(i * 50)))
        }
    }
}
