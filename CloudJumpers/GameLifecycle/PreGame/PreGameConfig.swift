//
//  PreGameConfig.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 12/4/22.
//

import Foundation

protocol PreGameConfig {
    var name: String { get }

    var seed: Int { get }

    var minimumPlayers: Int { get }
    var maximumPlayers: Int { get }

    func createPreGameManager(_ lobbyId: NetworkID) -> PreGameManager

    mutating func setSeed(_ seed: Int)
}
