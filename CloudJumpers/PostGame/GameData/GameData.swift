//
//  GameData.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 31/3/22.
//

import Foundation

protocol GameData: Codable {
    var lobbyId: NetworkID { get }
    var playerId: NetworkID { get }
    var playerName: String { get }
    var seed: Int { get }
    var gameMode: String { get }
}
