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
    weak var gameDataTracker: GameMetaDataDelegate?

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
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity),
              displacement.dx != 0
        else { return }

        let moveAction = SKAction.moveBy(x: displacement.dx,
                                         y: CGFloat.zero,
                                         duration: 1)

        let doneAction = SKAction.run({
            spriteComponent.node.removeAllActions()
        })
        let moveActionWithEnd = SKAction.sequence([moveAction, doneAction])
        spriteComponent.node.run(moveActionWithEnd)

        spriteComponent.node.xScale = abs(spriteComponent.node.xScale) * (displacement.dx / abs(displacement.dx) )

        // Animation portion, will abstract out later
        if spriteComponent.node.action(forKey: "moveCharacter") == nil {
          // if legs are not moving, start them
            let moveAnimation = SKAction.animate(with: Textures.character1.walking,
                                                 timePerFrame: 0.3,
                                                 resize: false,
                                                 restore: true )
            spriteComponent.node.run(SKAction.repeatForever(moveAnimation), withKey: "moveCharacter")
        }

        gameDataTracker?.updatePlayerPosition(position: spriteComponent.node.position)
    }
}
