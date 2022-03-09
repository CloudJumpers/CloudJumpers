//
//  SinglePlayerGameEngine.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

class SinglePlayerGameEngine: GameEngine {
    var entities: Set<GameEntity> = []

    var renderEntities: Set<RenderEntity> = []

    func update(_ deltaTime: Double) {
        // Update individual systems
    }

}
