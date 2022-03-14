//
//  Entity.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

class Entity: Hashable {
    var id = UUID()
    var type: EntityType

    init(type: EntityType) {
        self.type = type
    }

    enum EntityType {
<<<<<<< HEAD
        case player, guest, cloud, platform, ui
=======
        case player,guest,cloud,platform,ui,outerstick,innerstick
>>>>>>> main
    }

    static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
