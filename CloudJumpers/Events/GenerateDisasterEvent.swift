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

    private var maxY: CGFloat

    init(within highestHeight: CGFloat) {
        timestamp = EventManager.timestamp
        self.entityID = EntityManager.newEntityID
        self.maxY = highestHeight
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard getProbabilisticSuccess(successRate: 1) else {
            return nil
        }

        let randomPosition = getRandomPosition(within: maxY)
        let randomVelocity = getRandomVelocity()

        let disasterPrompt = DisasterPrompt(.meteor, at: randomPosition)
        entityManager.add(disasterPrompt)

        let disaster = Disaster(.meteor, at: randomPosition, velocity: randomVelocity)

        return [FadeEntityEvent(on: disasterPrompt, until: Constants.disasterPromptPeriod, fadeType: .fadeIn),
                RemoveEntityEvent(disasterPrompt, after: Constants.disasterPromptPeriod),
                DeferredEvent(disaster, until: {
                    entityManager.entity(with: disasterPrompt.id) == nil
                }, action: {
                    entityManager.add(disaster)
                    return [RemoveUnboundEntityEvent(disaster)]
                })
            ]
    }

    private func getRandomVelocity() -> CGVector {
        let xDir = Double.random(between: -1, and: 1)
        let yDir = Double.random(between: -1, and: 0)
        let velocity = Double.random(between: 100, and: 170)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    private func getRandomPosition(within maxY: CGFloat) -> CGPoint {
        CGPoint(
            x: Double.random(between: -300, and: 300),
            y: Double.random(between: -100, and: maxY - 100))
    }

    private func getProbabilisticSuccess(successRate: Int) -> Bool {
        Int.random(in: 0..<100) < successRate
    }
}
