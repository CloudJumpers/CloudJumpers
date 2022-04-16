//
//  TeleportSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class TeleportSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard let teleportComponents = manager?.components(ofType: TeleportComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let playerPositionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else { return }

        for component in teleportComponents where !component.isActivated {
            component.isActivated = true

            let activatorId = component.activatorId
            let playerLocation = playerPositionComponent.position

            if canAffectEntity(activatorEntityId: activatorId, targetEntityId: playerEntity.id) &&
                isAffectingLocation(location: playerLocation, teleportComponent: component) {

                // TODO: test for edge cases where players teleport to center of floor/wall/cloud
                playerPositionComponent.position = component.position
            }
        }
    }

    private func isAffectingLocation(location: CGPoint, teleportComponent: TeleportComponent) -> Bool {
        true
    }

    private func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId == targetEntityId
    }
}
