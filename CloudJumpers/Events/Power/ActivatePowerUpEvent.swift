//
//  ActivatePowerUpEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import SpriteKit

struct ActivatePowerUpEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var location: CGPoint

    init(in entity: Entity, location: CGPoint) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.location = location
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        guard let entity = entityManager.entity(with: entityID),
              let inventoryComponent = entityManager.component(ofType: InventoryComponent.self, of: entity),
              let powerUpEntityID = inventoryComponent.inventory.dequeue(),
              let powerUpEntity = entityManager.entity(with: powerUpEntityID),
              let powerUpComponent = entityManager.component(ofType: PowerUpComponent.self, of: powerUpEntity)
        else { return nil }

        let powerUpEffectStartEvent = PowerUpEffectStartEvent(position: location, powerUpType: powerUpComponent.kind)
        let remotePowerUpEffectStartEvent = ExternalPowerUpStartEvent(activatePowerUpPositionX: location.x,
                                                                      activatePowerUpPositionY: location.y,
                                                                      activatePowerUpType: powerUpComponent.kind.name)

        let localEvents: [Event] = [RemoveEntityEvent(powerUpEntityID), powerUpEffectStartEvent]
        let remoteEvents: [RemoteEvent] = [remotePowerUpEffectStartEvent]

        return (localEvents, remoteEvents)
    }
}
