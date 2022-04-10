//
//  DisasterPlatformCollideEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//
import Foundation

struct DisasterPlatformCollideEvent: Event {
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        <#code#>
    }
    
    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(from entityID: EntityID, on otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.otherEntityID = otherEntityID
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let disaster = entityManager.entity(with: entityID),
              let otherEntity = entityManager.entity(with: otherEntityID)
        else { return }

        supplier.add(RemoveEntityEvent(disaster.id))
    }
}
