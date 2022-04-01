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
        guard getProbabilisticSuccess(successRate: 1) else {
            return nil
        }

        let disaster = Disaster(getRandomType(),
                                position: getRandomPosition(entityManager),
                                velocity: getRandomVelocity())
        entityManager.add(disaster)

        return nil
    }

    private func getRandomVelocity() -> CGVector {
        let xDir = getRandomDouble(from: -1, to: 1)
        let yDir = getRandomDouble(from: -1, to: 0)
        let velocity = getRandomDouble(from: 100, to: 170)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    private func getRandomPosition(_ entityManager: EntityManager) -> CGPoint {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity) else {
            return Constants.defaultPosition
        }

        let minY = spriteComponent.node.position.y + 300
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
}
