//
//  MoveEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import Foundation
import CoreGraphics
import SpriteKit

struct MoveEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let displacement: CGVector

    init(on entity: Entity, by displacement: CGVector) {
        timestamp = EventManager.timestamp
        entityID = entity.id
        self.displacement = displacement
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, by displacement: CGVector) {
        entityID = id
        self.timestamp = timestamp
        self.displacement = displacement
    }

    func execute(in entityManager: EntityManager) {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return }

        let moveAction = SKAction.move(by: displacement, duration: 0.1)

        spriteComponent.node.run(moveAction)

        spriteComponent.node.xScale = abs(spriteComponent.node.xScale) * (displacement.dx / abs(displacement.dx) )

        SoundManager.instance.play(.walking)
    }
}
