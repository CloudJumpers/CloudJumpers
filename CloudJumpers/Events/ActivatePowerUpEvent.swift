//
//  ActivatePowerUpEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import SpriteKit

class ActivatePowerUpEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var location: CGPoint

    init(on entity: Entity, location: CGPoint) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.location = location
    }

    func execute(in entityManager: EntityManager) {
        guard let entity = entityManager.entity(with: entityID),
              let inventoryComponent = entityManager.component(ofType: InventoryComponent.self,
                                                               of: entity),
              let eventId = inventoryComponent.dequeue(),
              let powerUpEntity = entityManager.entity(with: eventId) as? PowerUp,
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self,
                                                            of: powerUpEntity)
        else { return }

        switch powerUpEntity.type {
        case .freeze:
            let freezeEffect = PowerUpEffect(at: location, type: .freeze)
            entityManager.add(freezeEffect)
        case .confuse:
            let confuseEffect = PowerUpEffect(at: location, type: .confuse)
            entityManager.add(confuseEffect)
        }

        spriteComponent.removeNodeFromScene = true
        // TODO: handle effects on other players
    }
}
