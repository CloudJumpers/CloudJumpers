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

    init(by entityID: EntityID, at location: CGPoint, timestamp: TimeInterval) {
        self.timestamp = timestamp
        self.entityID = entityID
        self.location = location
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        let targets = playersWithinRange(in: entityManager)
        let effectEntity = createEffectAndAdd(into: &supplier)
        target.add(effectEntity)

        targets.forEach { supplier.add(NullMoveEffector(on: $0, watching: effectEntity)) }
        targets.forEach { supplier.add(NullJumpEffector(on: $0, watching: effectEntity)) }
    }

    private func createEffectAndAdd(into supplier: inout Supplier) -> Entity {
        let effect = PowerUpEffect(.freeze, at: location, intervalToRemove: Constants.powerUpEffectDuration)
        supplier.add(BlinkEvent(
            onEntityWith: effect.id,
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
            let targetRange = (Constants.powerUpEffectSize.width + Constants.playerSize.width) / 2
            if location.distance(to: targetPosition) <= targetRange {
                targets.append(entity)
            }
        }

        return targets
    }
}
