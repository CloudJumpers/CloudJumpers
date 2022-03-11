//
//  Entity.swift
//  Cloud Jumpers
//
//  Created by Trong Tan on 3/8/22.
//

import Foundation

class Entity: Hashable {
    var id = UUID()
    
    enum EntityType {
        case player,guest,cloud,platform,ui
    }
    
    static func == (lhs: Entity, rhs: Entity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
