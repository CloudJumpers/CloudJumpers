//
//  KingHillData.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/16/22.
//

import Foundation

struct KingOfTheHillData: LocalCompletionData {
    let playerId: NetworkID
    let playerName: String
    let completionScore: Double
    let kills: Int
    let deaths: Int
}
