//
//  SoundEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation

struct SoundEvent: Event {
    var entityID: EntityID

    var timestamp: TimeInterval
    var soundName: Sounds

    init(_ soundName: Sounds) {
        timestamp = EventManager.timestamp
        self.soundName = soundName
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        SoundManager.instance.play(soundName)
    }
}
