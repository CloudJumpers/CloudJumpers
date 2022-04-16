//
//  MoveEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import CoreGraphics
import Foundation

struct MoveEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    let displacement: CGVector

    init(onEntityWith id: EntityID, by displacement: CGVector, at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        entityID = id
        self.displacement = displacement
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let positionSystem = target.system(ofType: PositionSystem.self) else {
            return
        }

        positionSystem.move(entityWith: entityID, by: displacement)
        positionSystem.changeSide(entityWith: entityID, by: displacement)
    }
}
