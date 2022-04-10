//
//  RespawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

struct RespawnEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID

    let newPosition: CGPoint

    init(onEntityWith id: EntityID, newPosition: CGPoint,at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        self.entityID = id
        self.newPosition = newPosition
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        target.add(RepositionEvent(onEntityWith: entityID, to: newPosition))
        target.add(BlinkEvent(
            onEntityWith: entityID,
            duration: Constants.respawnDuration,
            numberOfLoop: Constants.respawnLoopCount))
    }
}
