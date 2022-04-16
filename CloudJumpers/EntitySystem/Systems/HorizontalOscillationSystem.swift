//
//  HorizontalOscillationSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 16/4/22.
//

import Foundation
import CoreGraphics

class HorizontalOscillationSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let horizontalOscillationComponents = manager?.components(ofType: HorizontalOscillationComponent.self)
        else { return }

        for component in horizontalOscillationComponents {
            if let entity = component.entity,
               let positionComponent = manager?.component(ofType: PositionComponent.self, of: entity) {

                let displacement = component.horizontalVelocity * time
                positionComponent.position.x += displacement
            }
        }
    }

    func reverseDirection(of entityID: EntityID) {
        guard let entity = manager?.entity(with: entityID),
              let horizontalOscillationComponent = manager?.component(
                ofType: HorizontalOscillationComponent.self,
                of: entity)
        else { return }

        horizontalOscillationComponent.horizontalVelocity *= -1
    }
}
