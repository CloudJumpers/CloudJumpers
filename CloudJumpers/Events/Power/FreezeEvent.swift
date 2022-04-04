//
//  FreezeEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

import Foundation
import SpriteKit

struct FreezeEvent: Event {
    var timestamp: TimeInterval
    var entityID: EntityID

    private let location: CGPoint

    init(by entity: Entity, at location: CGPoint) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.location = location
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        let targets = playersWithinRange(in: entityManager)
        let effectEntity = createEffectAndAdd(into: &supplier)

        targets.forEach { supplier.add(NullMoveEffector(on: $0, watching: effectEntity)) }
    }

    private func createEffectAndAdd(into supplier: inout Supplier) -> Entity {
        let effect = PowerUpEffect(.freeze, at: location)
        supplier.add(RemoveEntityEvent(effect.id, after: Constants.powerUpEffectDuration))
        supplier.add(BlinkEffectEvent(
            on: effect.id,
            duration: Constants.powerUpEffectDuration / 10,
            numberOfLoop: 5))

        return effect
    }

    private func playersWithinRange(in entityManager: EntityManager) -> [Entity] {
        var targets: [Entity] = []

        for entity in entityManager.iterableEntities where entity is Player || entity is Guest {
            guard let sprite = entityManager.component(ofType: SpriteComponent.self, of: entity) else {
                fatalError("\(String(describing: entity)) does not possess a SpriteComponent")
            }

            let targetPosition = sprite.node.position
            if location.distance(to: targetPosition) <= Constants.powerUpEffectSize.width * 2 {
                targets.append(entity)
            }
        }

        return targets
    }
}
