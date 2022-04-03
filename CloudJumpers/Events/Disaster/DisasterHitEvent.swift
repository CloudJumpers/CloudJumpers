//
//  DisasterHitEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//
import Foundation

struct DisasterHitEvent: Event {
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

        if otherEntity is Player {
            supplier.add(RespawnEvent(onEntityWith: otherEntityID, to: Constants.playerInitialPosition))
            supplier.add(ExternalRemoveEvent(entityToRemoveId: disaster.id))
            supplier.add(ExternalRespawnEvent(
                positionX: Constants.playerInitialPosition.x,
                positionY: Constants.playerInitialPosition.y
            ))
        }
    }
}
