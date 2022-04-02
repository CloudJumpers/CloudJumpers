//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation

protocol GameRules {
    func prepareGameModes(gameEngine: GameEngine, blueprint: Blueprint)

    func createGameEvents(with gameData: GameMetaData) -> (localEvents: [Event], remoteEvents: [RemoteEvent])

    func hasGameEnd(with gameData: GameMetaData) -> Bool
}
