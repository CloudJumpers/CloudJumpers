//
//  Entity.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation
import SpriteKit

class Entity: Hashable {
    var id = UUID()
    var type: EntityType

    init(type: EntityType) {
        self.type = type
    }

    static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
