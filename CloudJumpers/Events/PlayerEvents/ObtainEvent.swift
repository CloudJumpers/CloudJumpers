//
//  ObtainEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation

struct ObtainEvent: Event {

    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(on entityID: EntityID, obtains otherEntityID: EntityID, at timestamp: TimeInterval = EventManager.timestamp) {
        self.entityID = entityID
        self.otherEntityID = otherEntityID
        self.timestamp = timestamp
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard target.entity(with: entityID) != nil,
              target.entity(with: otherEntityID) != nil,
              let inventorySystem = target.system(ofType: InventorySystem.self)
        else { return }

        inventorySystem.enqueueItem(for: entityID, with: otherEntityID)
    }

    private func incrementMetric(in target: EventModifiable) {
        guard let metricsSystem = target.system(ofType: MetricsSystem.self) else {
            return
        }

        metricsSystem.incrementMetric(String(describing: ObtainEvent.self))
    }
}
