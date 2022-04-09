//
//  JumpEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import Foundation
import SpriteKit

struct JumpEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID
    let jumpImpulse: CGVector

    init(on entity: Entity, by impulse: CGVector = Constants.jumpImpulse) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        jumpImpulse = impulse
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, by impulse: CGVector) {
        entityID = id
        self.timestamp = timestamp
        jumpImpulse = impulse
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        guard let entity = entityManager.entity(with: entityID),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              !isJumping(body: physicsComponent.body)
        else { return }

        physicsComponent.body.applyImpulse(jumpImpulse)
    }

    private func isJumping(body: SKPhysicsBody) -> Bool {
        abs(body.velocity.dy) > Constants.jumpYTolerance
    }
}
