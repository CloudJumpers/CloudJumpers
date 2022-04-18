//
//  BlackoutSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class BlackoutSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard let blackoutComponents = manager?.components(ofType: BlackoutComponent.self),
              let playerEntity = manager?.components(ofType: PlayerTag.self).first?.entity,
              let playerPositionComponent = manager?.component(ofType: PositionComponent.self, of: playerEntity)
        else { return }

        for component in blackoutComponents where !component.isActivated {
            component.isActivated = true

            let activatorId = component.activatorId
            let playerLocation = playerPositionComponent.position
            if let entity = component.entity,
               let spriteComponent = manager?.component(ofType: SpriteComponent.self, of: entity) {
                spriteComponent.alpha = 0
            }

            if canAffectEntity(activatorEntityId: activatorId, targetEntityId: playerEntity.id) &&
                isAffectingLocation(location: playerLocation, blackoutComponent: component),
               let areaComponent = manager?.components(ofType: AreaComponent.self).first {

                areaComponent.isBlank = true
            }
        }
    }

    private func isAffectingLocation(location: CGPoint, blackoutComponent: BlackoutComponent) -> Bool {
        true
    }

    private func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId != targetEntityId
    }
}
