//
//  KillEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 18/4/22.
//

import Foundation
import CoreGraphics

struct KillEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID
    var targetID: EntityID

    let newPosition: CGPoint

    init(
        byEntityWith id: EntityID,
        targetID: EntityID,
        newPosition: CGPoint,
        at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        self.entityID = id
        self.targetID = targetID
        self.newPosition = newPosition
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let player = target.system(ofType: PlayerStateSystem.self)?.getPlayerEntity(),
              player.id == targetID else {
            return
        }

        target.add(RespawnEvent(onEntityWith: player.id, killedBy: entityID, newPosition: newPosition))
    }
}
