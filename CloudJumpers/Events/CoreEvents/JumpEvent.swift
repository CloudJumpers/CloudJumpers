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

    init(onEntityWith id: EntityID, by impulse: CGVector = Constants.jumpImpulse) {
        timestamp = EventManager.timestamp
        entityID = id
        jumpImpulse = impulse
    }

    init(onEntityWith id: EntityID, at timestamp: TimeInterval, by impulse: CGVector) {
        entityID = id
        self.timestamp = timestamp
        jumpImpulse = impulse
    }
    
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        <#code#>
    }
}
