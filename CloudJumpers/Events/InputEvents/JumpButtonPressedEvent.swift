//
//  JumpButtonPressedEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/16/22.
//

import Foundation

import CoreGraphics

struct JumpButtonPressedEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    init(at timestamp: TimeInterval = EventManager.timestamp) {
        self.timestamp = timestamp
        self.entityID = EntityID()
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let playerSystem = target.system(ofType: PlayerStateSystem.self),
              let player = playerSystem.getPlayerEntity()
        else {
            return
        }
        let jumpEvent = JumpEvent(onEntityWith: player.id)
        let soundEvent = SoundEvent(.jumpCape).then(do: SoundEvent(.jumpFoot))

        // TODO: Figure out how to integrate AnimateEvent into JumpEvent
        let animateEvent = AnimateEvent(onEntityWith: player.id, to: CharacterFrames.jumping.key)

        supplier.add(jumpEvent.then(do: soundEvent))
        supplier.add(animateEvent)
    }
}
