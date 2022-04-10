//
//  DisasterPlayerCollideEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//
import Foundation

struct DisasterPlayerCollideEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(from entityID: EntityID, on otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.otherEntityID = otherEntityID
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let disaster = target.entity(with: entityID),
              let otherEntity = target.entity(with: otherEntityID)
        else { return }

        supplier.add(RemoveEntityEvent(disaster.id))
        supplier.add(RespawnEvent(onEntityWith: otherEntityID, newPosition: Constants.playerInitialPosition))
        supplier.add(ExternalRemoveEvent(entityToRemoveId: disaster.id))
        supplier.add(ExternalRespawnEvent(
            positionX: Constants.playerInitialPosition.x,
            positionY: Constants.playerInitialPosition.y
        ))
    }
}
