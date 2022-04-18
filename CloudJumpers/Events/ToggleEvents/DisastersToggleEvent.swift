//
//  DisasterSystemActivationEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 18/4/22.
//

import Foundation

struct DisastersToggleEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID
    private let shouldEnable: Bool

    init(_ shouldEnable: Bool, at timestamp: TimeInterval = EventManager.timestamp) {
        self.entityID = EntityID()
        self.timestamp = timestamp
        self.shouldEnable = shouldEnable
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let disasterSpawnSystem = target.system(ofType: DisasterSpawnSystem.self) else {
            return
        }
        disasterSpawnSystem.setActive(active: shouldEnable)
    }
}
