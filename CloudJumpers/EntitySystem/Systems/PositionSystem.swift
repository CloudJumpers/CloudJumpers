//
//  PositionSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

class PositionSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
    }

    func move(entityWith id: EntityID, to position: CGPoint) {
        guard let positionComponent = manager?.component(ofType: PositionComponent.self, of: id) else {
            return
        }

        positionComponent.position = position
    }

    func move(entityWith id: EntityID, by displacement: CGVector) {
        guard let positionComponent = manager?.component(ofType: PositionComponent.self, of: id) else {
            return
        }

        positionComponent.position += displacement
    }
}
