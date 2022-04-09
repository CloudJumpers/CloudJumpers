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
    
    init(onEntityWith id: EntityID, to newPosition: CGPoint) {
        timestamp = EventManager.timestamp
        entityID = id
        self.newPosition = newPosition
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, to newPosition: CGPoint) {
        entityID = id
        self.timestamp = timestamp
        self.newPosition = newPosition
    }
    
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        return
    }
    
    
}
