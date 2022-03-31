//
//  TimeTrialData.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

struct TimeTrialData: GameData {
    let lobbyId: NetworkID
    let playerId: NetworkID
    let playerName: String
    let seed: Int
    let gameMode: String
    let completionTime: Double
}
