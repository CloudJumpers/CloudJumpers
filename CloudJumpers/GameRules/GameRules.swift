//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation

protocol GameRules {
    func prepareGameModes(gameEngine: GameEngine,
                          cloudBlueprint: Blueprint,
                          powerUpBlueprint: Blueprint)

    func createGameEvents(with gameData: GameMetaData) -> [Event]

    func hasGameEnd(with gameData: GameMetaData) -> Bool
}
