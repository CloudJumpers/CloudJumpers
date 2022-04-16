//
//  CloudWallCollideEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 16/4/22.
//

import Foundation

struct CloudWallCollideEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(cloud cloudID: EntityID, wall wallID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = cloudID
        self.otherEntityID = wallID
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let horizontalOscillationSystem = target.system(ofType: HorizontalOscillationSystem.self) else {
            return
        }

        horizontalOscillationSystem.reverseDirection(of: entityID)
    }
}
