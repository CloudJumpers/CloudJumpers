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

    private var crossDeviceSyncTimer: Timer?

    required init(for manager: EntityManager) {
        self.manager = manager
        setUpCrossDeviceSyncTimer()
    }

    deinit {
        crossDeviceSyncTimer?.invalidate()
    }

    func update(within time: CGFloat) {
        }

    private func setUpCrossDeviceSyncTimer() {
        crossDeviceSyncTimer = Timer.scheduledTimer(
            withTimeInterval: GameConstants.positionalUpdateIntervalSeconds,
            repeats: true
        ) { [weak self] _ in self?.uploadLocalPlayerState() }
    }

    func uploadLocalPlayerState() {
        guard let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity),
              let animationComponent = manager?.component(ofType: AnimationComponent.self, of: playerEntity),
              let animation = animationComponent.activeAnimation
        else { return }

        // TODO: Change after new way of getting sprite texture
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
