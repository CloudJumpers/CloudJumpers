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

    private var boundSize: CGSize?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
    }

    convenience init(for manager: EntityManager, boundSize: CGSize, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.init(for: manager, dispatchesVia: dispatcher)
        self.boundSize = boundSize
    }

    func update(within time: CGFloat) {
        guard let horizontalOscillationComponents = manager?.components(ofType: HorizontalOscillationComponent.self)
        else { return }

        for component in horizontalOscillationComponents {
            if let entity = component.entity,
               let positionComponent = manager?.component(ofType: PositionComponent.self, of: entity),
               let physicsComponent = manager?.component(ofType: PhysicsComponent.self, of: entity) {

                if isHittingBoundary(positionComponent: positionComponent, physicsComponent: physicsComponent) {
                    reverseDirection(of: entity.id)
                }

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

    private func isHittingBoundary(positionComponent: PositionComponent, physicsComponent: PhysicsComponent) -> Bool {
        guard let size = physicsComponent.size,
              let boundSize = boundSize else {
                  return false
              }

        return positionComponent.position.x - (size.width / 2) <= -boundSize.width / 2 ||
        positionComponent.position.x + (size.width / 2) >= boundSize.width / 2
    }
}
