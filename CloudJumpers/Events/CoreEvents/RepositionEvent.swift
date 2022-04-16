//
//  RepositionEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

struct RepositionEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID

    let newPosition: CGPoint

    init(onEntityWith id: EntityID, to newPosition: CGPoint, at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        entityID = id
        self.newPosition = newPosition
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let positionSystem = target.system(ofType: PositionSystem.self) else {
            return
        }

        positionSystem.move(entityWith: entityID, to: newPosition)
    }
}
