//
//  ConfuseEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

import Foundation
import SpriteKit

struct ConfuseEvent: Event {
    var timestamp: TimeInterval
    var entityID: EntityID

    private let location: CGPoint

    init(by entity: Entity, at location: CGPoint) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.location = location
    }

    init(by entityID: EntityID, at location: CGPoint, timestamp: TimeInterval) {
        self.timestamp = timestamp
        self.entityID = entityID
        self.location = location
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        let targets = playersWithinRange(in: entityManager)
        let effectEntity = createEffectAndAdd(into: &supplier)
        entityManager.add(effectEntity)

        targets.forEach { supplier.add(SwapMoveEffector(on: $0, watching: effectEntity)) }
    }

    private func createEffectAndAdd(into supplier: inout Supplier) -> Entity {
        let effect = PowerUpEffect(.confuse, at: location)
        supplier.add(RemoveEntityEvent(effect.id, after: Constants.powerUpEffectDuration))
        supplier.add(BlinkEffectEvent(
            on: effect.id,
            duration: Constants.powerUpEffectDuration / 10,
            numberOfLoop: 5))

        return effect
    }

    private func isTarget(_ entity: Entity) -> Bool {
        entity is Player && entity.id != entityID
    }

    private func playersWithinRange(in entityManager: EntityManager) -> [Entity] {
        var targets: [Entity] = []

        for entity in entityManager.iterableEntities where isTarget(entity) {
            guard let sprite = entityManager.component(ofType: SpriteComponent.self, of: entity) else {
                fatalError("\(String(describing: entity)) does not possess a SpriteComponent")
            }

            let targetPosition = sprite.node.position
            if location.distance(to: targetPosition) <= (Constants.powerUpEffectSize.width + Constants.playerSize.width) / 2 {
                print(location.distance(to: targetPosition))
                targets.append(entity)
            }
        }

        return targets
    }
}
