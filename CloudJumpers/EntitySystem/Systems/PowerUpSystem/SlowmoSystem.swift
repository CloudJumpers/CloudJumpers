//
//  SlowmoSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 15/4/22.
//

import Foundation
import CoreGraphics

class SlowmoSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard let slowmoComponents = manager?.components(ofType: SlowmoComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else { return }

        for component in slowmoComponents where !component.isActivated {
            component.isActivated = true

            let activatorId = component.activatorId
            let playerLocation = positionComponent.position
            if canAffectEntity(activatorEntityId: activatorId, targetEntityId: playerEntity.id) &&
                isAffectingLocation(location: playerLocation, slowmoComponent: component),
               let effectEntity = component.entity {

                dispatcher?.add(SlowMoveEffector(on: playerEntity, watching: effectEntity))
            }
        }
    }

    private func isAffectingLocation(location: CGPoint, slowmoComponent: SlowmoComponent) -> Bool {
        slowmoComponent.position.distance(to: location) <= slowmoComponent.radiusRange
    }

    private func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId != targetEntityId
    }
}
