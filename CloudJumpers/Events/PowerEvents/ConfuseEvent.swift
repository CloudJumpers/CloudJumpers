//
//  ConfuseEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

import Foundation
import SpriteKit

struct ConfuseEvent: Event {
    var timestamp: TimeInterval
    var entityID: EntityID

    private let watchingEntityID: EntityID

    init(onEntityWith id: EntityID, watchingEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.watchingEntityID = watchingEntityID
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = target.entity(with: entityID),
              let watchingEntity = target.entity(with: watchingEntityID) else {
            return
        }

        supplier.add(SwapMoveEffector(on: entity, watching: watchingEntity))
    }
}
