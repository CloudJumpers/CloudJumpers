//
//  ChangeStandOnLocationEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/12/22.
//

import Foundation

struct ChangeStandOnLocationEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let standOnEntityID: EntityID?

    init(on entityID: EntityID, standOnEntityID: EntityID?) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.standOnEntityID = standOnEntityID
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let standOnSystem = target.system(ofType: StandOnSystem.self)
        else { return }
        standOnSystem.changeStandOnEntity(for: entityID, to: standOnEntityID, at: timestamp)
    }
}
