//
//  GameModes.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/24/22.
//

import Foundation

protocol GameRules {
    func update()
    func hasGameEnd() -> Bool

    func fetchLocalCompletionData()
}
extension GameRules {
    func update() { }
}
