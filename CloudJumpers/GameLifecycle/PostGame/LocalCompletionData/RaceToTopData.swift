//
//  RaceToTopData.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

struct RaceToTopData: LocalCompletionData {
    let playerId: NetworkID
    let playerName: String
    let completionTime: Double
    let kills: Int
    let deaths: Int
}
