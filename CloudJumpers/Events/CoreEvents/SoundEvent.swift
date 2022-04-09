//
//  SoundEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation

struct SoundEvent: Event {
    var timestamp: TimeInterval
    
    var entityID: EntityID
    
    var soundName: Sounds
    
    init(onEntityWith id: EntityID, soundName: Sounds) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.soundName = soundName
    }
    
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        SoundManager.instance.play(soundName)
    }
    
    
}
