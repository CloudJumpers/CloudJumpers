//
//  GenerateDisasterEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 1/4/22.
//

import Foundation
import CoreGraphics

struct GenerateDisasterEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    init(entityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard getProbabilisticSuccess(successRate: 1),
              let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else {
            return nil
        }

        let yPosition = spriteComponent.node.position.y
        let disaster = Disaster(getRandomType(),
                                position: getRandomPosition(minY: yPosition + 300),
                                velocity: getRandomVelocity())
        entityManager.add(disaster)

        guard let disasterSpriteComponent = entityManager.component(ofType: SpriteComponent.self, of: disaster) else {
            return []
        }

        return [DeferredEvent(disaster,
                              until: { isPositionOutOfBound(position: disasterSpriteComponent.node.position) },
                              action: { entityManager.remove(disaster) })]
    }

    private func getRandomVelocity() -> CGVector {
        let xDir = getRandomDouble(from: -1, to: 1)
        let yDir = getRandomDouble(from: -1, to: 0)
        let velocity = getRandomDouble(from: 100, to: 170)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    private func getRandomPosition(minY: CGFloat) -> CGPoint {
        var disasterPosition = CGPoint(x: 0.0, y: 0.0)
        disasterPosition.x = getRandomDouble(from: -300, to: 300)
        let maxY = minY + 500
        disasterPosition.y = getRandomDouble(from: minY, to: maxY)

        return disasterPosition
    }

    private func getRandomDouble(from: Double, to: Double) -> Double {
        Double.random(in: from...to)
    }

    private func getRandomType() -> DisasterComponent.Kind {
        .meteor
    }

    private func getProbabilisticSuccess(successRate: Int) -> Bool {
        Int.random(in: 0..<100) < successRate
    }

    private func isPositionOutOfBound(position: CGPoint) -> Bool {
        position.x < -480 || position.x > 480
    }
}
