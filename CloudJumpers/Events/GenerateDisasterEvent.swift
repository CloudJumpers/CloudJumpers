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

    init(within highestHeight: CGFloat, entityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.maxY = highestHeight
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        guard getProbabilisticSuccess(successRate: 1) else {
            return nil
        }

        let randomPosition = getRandomPosition(within: maxY)
        let randomVelocity = getRandomVelocity()
        let disasterType = getRandomType() ?? .meteor

        return ([DisasterStartEvent(
            position: randomPosition,
            velocity: randomVelocity,
            disasterType: disasterType,
            playerId: entityID)], nil)

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

    private func getRandomType() -> DisasterComponent.Kind? {
        DisasterComponent.Kind.allCases.randomElement()
    }
}
