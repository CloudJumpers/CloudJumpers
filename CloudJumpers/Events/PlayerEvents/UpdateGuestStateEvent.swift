//
//  UpdatePlayerEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

struct UpdateGuestStateEvent: Event {
    var timestamp: TimeInterval
    var entityID: EntityID

    let position: CGPoint
    let key: AnimationKey

    init(
        onEntityWith id: EntityID,
        position: CGPoint,
        animationWith key: AnimationKey,
        at timestamp: TimeInterval = EventManager.timestamp) {

        entityID = id
        self.position = position
        self.key = key
        self.timestamp = timestamp
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        target.add(RepositionEvent(onEntityWith: entityID, to: position))
        target.add(AnimateEvent(onEntityWith: entityID, to: key))
    }
}
