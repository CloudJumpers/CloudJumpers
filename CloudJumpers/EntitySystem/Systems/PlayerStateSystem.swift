//
//  PlayerStateSynchonizer.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class PlayerStateSystem: System {
    var active = true

    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func uploadLocalPlayerState() {
        guard let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let animationComponent = manager?.component(ofType: AnimationComponent.self, of: playerEntity),
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else {
            return
        }
        // TODO: Change after new way of getting sprite texture
        let playerPosition = positionComponent.position
        let playerTexture = animationComponent.textures
        let positionalUpdate = ExternalRepositionEvent(
            positionX: playerPosition.x,
            positionY: playerPosition.y,
            texture: playerTexture.rawValue
        )

        manager?.dispatch(positionalUpdate)
    }

    func update(within time: CGFloat) {
        guard let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let animationComponent = manager?.component(ofType: AnimationComponent.self, of: playerEntity),
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity),
              let physicsComponent = manager?.component(ofType: PhysicsComponent.self, of: playerEntity)
        else {
            return
        }

    }

}
