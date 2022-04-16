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
    unowned var dispatcher: EventDispatcher?

    private var updateCounter: Int = .zero

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        updateCounter += 1
        if updateCounter == 6 {
            uploadLocalPlayerState()
            updateCounter = 0
        }
    }

    func uploadLocalPlayerState() {
        guard let playerEntity = getPlayerEntity(),
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity),
              let animationComponent = manager?.component(ofType: AnimationComponent.self, of: playerEntity),
              let animation = animationComponent.activeAnimation
        else { return }

        let playerPosition = positionComponent.position
        let playerTexture = animation.key

        let positionalUpdate = ExternalUpdateGuestStateEvent(
            positionX: playerPosition.x,
            positionY: playerPosition.y,
            animationKey: playerTexture
        )

        dispatcher?.dispatch(positionalUpdate)
    }

    func getPlayerEntity() -> Entity? {
        manager?.components(ofType: PlayerTag.self).first?.entity
    }
}
