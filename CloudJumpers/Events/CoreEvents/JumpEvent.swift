//
//  JumpEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

struct JumpEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID

    let jumpImpulse: CGVector

    init(onEntityWith id: EntityID,
         by impulse: CGVector = Constants.jumpImpulse,
         at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        entityID = id
        jumpImpulse = impulse
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let physicsSystem = target.system(ofType: PhysicsSystem.self) else {
            return
        }

        physicsSystem.applyImpulse(on: entityID, impulse: jumpImpulse)
    }
}
