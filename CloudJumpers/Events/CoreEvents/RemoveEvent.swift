//
//  RemoveEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation

struct RemoveEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID

    init(onEntityWith id: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = id
    }

    init(onEntityWith id: EntityID, timestamp: TimeInterval) {
        self.entityID = id
        self.timestamp = timestamp
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = target.entity(with: entityID) else {
            return
        }
        target.remove(entity)
    }

}
