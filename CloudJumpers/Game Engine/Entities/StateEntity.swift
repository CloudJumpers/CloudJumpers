//
//  RenderEntity.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

// State that persist throughout the game
class StateEntity: Entity {
    var id = UUID()
}

extension StateEntity: Hashable {
    static func == (lhs: StateEntity, rhs: StateEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
