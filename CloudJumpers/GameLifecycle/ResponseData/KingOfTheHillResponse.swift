//
//  KingOfTheHillResponse.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 17/4/22.
//

import Foundation

struct KingOfTheHillResponse: Response {
    let position: Int
    let userId: NetworkID
    let userDisplayName: String
    let score: Double
    let kills: Int
    let deaths: Int
}

struct KingOfTheHillResponses: Decodable {
    let topLobbyPlayers: [KingOfTheHillResponse]
}
