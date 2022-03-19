//
//  GameEndState.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/19/22.
//

import Foundation

class TimeTrialGameEndState {
    struct Score {
        let name: String
        let score: Double
    }

    var scores = [Score]()

    init(playerEndTime: Double) {
        scores.append(Score(name: "You", score: playerEndTime))
        fetchHighScorer()
    }

    func fetchHighScorer() {
        for i in 1...5 {
            scores.append(Score(name: "Friend", score: Double(i * 50)))
        }
    }
}
