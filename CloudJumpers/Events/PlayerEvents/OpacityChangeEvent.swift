//
//  OpacityChangeEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 18/4/22.
//

import Foundation

struct OpacityChangeEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID
    let alpha: Double

    init(on entityID: EntityID, opacity: Double, at timestamp: TimeInterval = EventManager.timestamp) {
        self.entityID = entityID
        self.alpha = opacity
        self.timestamp = timestamp
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let opacitySystem = target.system(ofType: OpacitySystem.self) else {
            return
        }
        opacitySystem.modifyAlpha(entityID, alpha: alpha)
    }
}
