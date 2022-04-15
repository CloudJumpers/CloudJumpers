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

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let confuseComponents = manager?.components(ofType: SlowmoComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let positionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else { return }

        for component in confuseComponents where !component.isActivated {
            component.isActivated = true

            let activatorId = component.activatorId
            let playerLocation = positionComponent.position
            if canAffectEntity(activatorEntityId: activatorId, targetEntityId: playerEntity.id) &&
                isAffectingLocation(location: playerLocation, slowmoComponent: component) {
                // TODO: supposedly add SlowmoEvent here
            }
        }
    }

    private func isAffectingLocation(location: CGPoint, slowmoComponent: SlowmoComponent) -> Bool {
        slowmoComponent.position.distance(to: location) <= slowmoComponent.radiusRange
    }

    func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId != targetEntityId
    }
}
