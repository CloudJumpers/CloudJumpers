//
//  BecomeGodEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/17/22.
//

import Foundation

struct PromoteGodEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID

    init(onEntityWith id: EntityID, at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        self.entityID = id
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let playerSystem = target.system(ofType: PlayerStateSystem.self) else {
            return
        }
        playerSystem.enableScrollableForPlayer(for: entityID)
    }
}
