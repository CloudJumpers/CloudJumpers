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
    
    init(onEntityWith id: EntityID, by displacement: CGVector) {
        timestamp = EventManager.timestamp
        entityID = id
        self.displacement = displacement
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, by displacement: CGVector) {
        entityID = id
        self.timestamp = timestamp
        self.displacement = displacement
    }
    
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        return
    }
    
    
}
