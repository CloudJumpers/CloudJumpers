//
//  PhysicsSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

class PhysicsSystem: System {
    var active: Bool = true
    
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }
    
    func update(within time: CGFloat) {
        guard let physicsComponents = manager?.components(ofType: PhysicsComponent.self) else {
            return
        }
        for component in physicsComponents {
            component.impulse = CGVector.zero
        }
    }
    
    func applyImpulse(for id: EntityID,  impulse: CGVector) {
        guard let physicsComponent = manager?.component(ofType: PhysicsComponent.self, of: id) else {
            return
        }
        physicsComponent.impulse += impulse
    }
}
