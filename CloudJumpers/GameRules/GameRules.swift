//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation

protocol GameRules {
    func hasGameEnd(with gameData: GameMetaData) -> Bool
}
