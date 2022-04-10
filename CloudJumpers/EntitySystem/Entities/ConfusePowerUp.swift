//
//  ConfusePowerUp.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 10/4/22.
//

import Foundation
import CoreGraphics

class ConfusePowerUp: PowerUp {
    let id: EntityID

    var position: CGPoint
    var kind = PowerUpComponent.Kind.confuse

    init(at position: CGPoint, with id: EntityID = EntityManager.newEntityID) {
        self.position = position
        self.id = id
        self.position = position
    }

    func activate(on entity: Entity, watching watchingEntity: Entity) -> [Effector] {
        [ SwapMoveEffector(on: entity, watching: watchingEntity) ]
    }
}
