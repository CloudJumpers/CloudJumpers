//
//  ConfuseSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class ConfuseSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let confuseComponents = manager?.components(ofType: ConfuseComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else { return }

        for component in confuseComponents where !component.isActivated {
            component.isActivated = true

            let activatorId = component.activatorId
            let playerLocation = positionComponent.position
            if canAffectEntity(activatorEntityId: activatorId, targetEntityId: playerEntity.id) &&
                isAffectingLocation(location: playerLocation, confuseComponent: component),
               let effectEntity = component.entity {

                dispatcher?.add(SwapMoveEffector(on: playerEntity, watching: effectEntity))
            }
        }
    }

    private func isAffectingLocation(location: CGPoint, confuseComponent: ConfuseComponent) -> Bool {
        confuseComponent.position.distance(to: location) <= confuseComponent.radiusRange
    }

    private func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId != targetEntityId
    }
}
