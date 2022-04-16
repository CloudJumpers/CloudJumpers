//
//  FreezeSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class FreezeSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let freezeComponents = manager?.components(ofType: FreezeComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else { return }

        for component in freezeComponents where !component.isActivated {
            component.isActivated = true

            let activatorId = component.activatorId
            let playerLocation = positionComponent.position
            if canAffectEntity(activatorEntityId: activatorId, targetEntityId: playerEntity.id) &&
                isAffectingLocation(location: playerLocation, freezeComponent: component),
               let effectEntity = component.entity {

                dispatcher?.add(NullMoveEffector(on: playerEntity, watching: effectEntity))
                dispatcher?.add(NullJumpEffector(on: playerEntity, watching: effectEntity))
            }
        }
    }

    private func isAffectingLocation(location: CGPoint, freezeComponent: FreezeComponent) -> Bool {
        freezeComponent.position.distance(to: location) <= freezeComponent.radiusRange
    }

    private func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId != targetEntityId
    }
}
