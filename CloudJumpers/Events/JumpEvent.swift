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

    init(on entity: Entity) {
        timestamp = EventManager.timestamp
        entityID = entity.id
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let physicsComponent = entityManager.component(ofType: PhysicsComponent.self, of: entity),
              !isJumping(body: physicsComponent.body)
        else { return nil }

        physicsComponent.body.applyImpulse(Constants.jumpImpulse)

        SoundManager.instance.play(.jumpFoot)
        SoundManager.instance.play(.jumpCape)

        return nil
    }

    private func isJumping(body: SKPhysicsBody) -> Bool {
        abs(body.velocity.dy) > Constants.jumpYTolerance
    }
}
