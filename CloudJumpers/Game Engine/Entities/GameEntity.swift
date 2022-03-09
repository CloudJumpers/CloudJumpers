//
//  GameEntity.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

class GameEntity: Entity {
    var id = UUID()
}

extension GameEntity: Hashable {
    static func == (lhs: GameEntity, rhs: GameEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
