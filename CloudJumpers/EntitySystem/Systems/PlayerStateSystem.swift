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

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        updateCounter = (updateCounter + 1) % GameConstants.positionalUpdateIntervalTicks
        if updateCounter == .zero {
            uploadLocalPlayerState()
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

    func enableScrollableForPlayer(for entityID: EntityID) {
        guard let manager = manager,
              let entity = manager.entity(with: entityID),
              manager.hasComponent(ofType: PlayerTag.self, in: entity),
              let areaComponent = manager.components(ofType: AreaComponent.self).first
        else {
            return
        }
        areaComponent.scrollable = true

    }
    func disableScrollableForPlayer(for entityID: EntityID) {
        guard let manager = manager,
              let entity = manager.entity(with: entityID),
              manager.hasComponent(ofType: PlayerTag.self, in: entity),
              let areaComponent = manager.components(ofType: AreaComponent.self).first
        else {
            return
        }

        areaComponent.scrollable = false
    }
}
