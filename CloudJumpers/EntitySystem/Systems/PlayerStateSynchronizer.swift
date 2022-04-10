//
//  PlayerStateSynchonizer.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class PlayerStateSynchronizer: System {
    var active = true

    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let manager = manager,
              let entity = manager.getEntities().first(where: {manager.hasComponent(ofType: PlayerTag.self, in: $0)}),
              let animationComponent = manager.component(ofType: AnimationComponent.self, of: entity),
              let positionComponent = manager.component(ofType: PositionComponent.self, of: entity)
        else {
            return
        }

        // TODO: Change after new way of getting sprite position
        let playerPosition = positionComponent.position
        let playerTexture = animationComponent.textures
        let positionalUpdate = ExternalRepositionEvent(
            positionX: playerPosition.x,
            positionY: playerPosition.y,
            texture: playerTexture.rawValue
        )

        manager.publish(positionalUpdate)
    }

}
