//
//  BlinkEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation

struct BlinkEvent: Event {
    var timestamp: TimeInterval
    
    var entityID: EntityID

    private var duration: Double
    private var numberOfLoop: Int

    init(onEntityWith id: EntityID, duration: Double, numberOfLoop: Int) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.duration = duration
        self.numberOfLoop = numberOfLoop
    }
    
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        return
    }
    
    
}
