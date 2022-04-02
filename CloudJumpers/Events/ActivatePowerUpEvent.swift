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

        let effect = PowerUpEffect(powerUpComponent.kind, at: location)
        entityManager.add(effect)

        return ([RemoveEntityEvent(effect, after: Constants.powerUpEffectDuration)], nil)
    }
}
