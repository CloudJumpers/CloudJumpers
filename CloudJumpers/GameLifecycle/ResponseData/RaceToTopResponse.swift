//
//  RaceToTopResponse.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 1/4/22.
//

import Foundation

struct RaceToTopResponse: Response {
    let position: Int
    let userId: NetworkID
    let userDisplayName: String
    let completionTime: Double
    let kills: Int
    let deaths: Int
}

struct RaceToTopResponses: Decodable {
    let topLobbyPlayers: [RaceToTopResponse]
}
