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

    init(towards entityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        guard getProbabilisticSuccess(successRate: 1),
              let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return nil }

        let yPosition = spriteComponent.node.position.y
        let randomPosition = getRandomPosition(minY: yPosition + 300)
        let randomVelocity = getRandomVelocity()

        let disaster = Disaster(.meteor, at: randomPosition, velocity: randomVelocity)
        entityManager.add(disaster)

        return ([RemoveUnboundEntityEvent(disaster)], nil)
    }

    private func getRandomVelocity() -> CGVector {
        let xDir = Double.random(between: -1, and: 1)
        let yDir = Double.random(between: -1, and: 0)
        let velocity = Double.random(between: 100, and: 170)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    private func getRandomPosition(minY: CGFloat) -> CGPoint {
        CGPoint(
            x: Double.random(between: -300, and: 300),
            y: Double.random(between: minY, and: minY + 500))
    }

    private func getProbabilisticSuccess(successRate: Int) -> Bool {
        Int.random(in: 0..<100) < successRate
    }
}
