//
//  PhysicsSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

class PhysicsSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard let physicsComponents = manager?.components(ofType: PhysicsComponent.self) else {
            return
        }
        for component in physicsComponents {
            component.impulse = CGVector.zero
        }
    }

    func applyImpulse(on entityID: EntityID, impulse: CGVector) {
        guard let physicsComponent = manager?.component(ofType: PhysicsComponent.self, of: entityID) else {
            return
        }

        physicsComponent.impulse += impulse
    }

    func isMoving(_ entityID: EntityID) -> Bool {
        guard let physicsComponent = manager?.component(ofType: PhysicsComponent.self, of: entityID) else {
            return false
        }

        return !physicsComponent.velocity.isZero
    }

    func isJumping(_ entityID: EntityID) -> Bool {
        guard let physicsComponent = manager?.component(ofType: PhysicsComponent.self, of: entityID) else {
            return false
        }

        return physicsComponent.velocity.dy.isZero
    }

    func sync(with entityVelocityMap: EntityVelocityMap) {
        for (entityID, velocity) in entityVelocityMap {
            guard let entity = manager?.entity(with: entityID),
                  let physicsComponent = manager?.component(ofType: PhysicsComponent.self, of: entity)
            else { continue }

            physicsComponent.velocity = velocity
        }
    }
}
