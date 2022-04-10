//
//  ObtainEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation

struct ObtainEvent: Event {

    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(on entityID: EntityID, obtains otherEntityID: EntityID, timestamp: TimeInterval = EventManager.timestamp) {
        self.entityID = entityID
        self.otherEntityID = otherEntityID
        self.timestamp = timestamp
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = target.entity(with: entityID),
              target.entity(with: otherEntityID) != nil
        else { return }

        if entity is Player,
           let inventorySystem = target.system(ofType: InventorySystem.self) {

            inventorySystem.enqueueItem(for: entityID, with: otherEntityID)
            return
        }

        target.remove(entity)
    }
}
