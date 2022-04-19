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
        supplier.add(RemoveEvent(onEntityWith: entityID))
        supplier.add(RespawnEvent(
            onEntityWith: otherEntityID,
            killedBy: entityID,
            newPosition: Positions.player))
        supplier.add(ExternalRemoveEvent(entityToRemoveId: entityID))
        supplier.add(ExternalRespawnEvent(
            positionX: Positions.player.x,
            positionY: Positions.player.y,
            killedBy: entityID))
    }
}
