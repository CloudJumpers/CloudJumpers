//
//  AnimateEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation

struct AnimateEvent: Event {
    var timestamp: TimeInterval
    var entityID: EntityID

    private let key: AnimationKey

    init(onEntityWith id: EntityID, to key: AnimationKey) {
        timestamp = EventManager.timestamp
        entityID = id
        self.key = key
    }

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        guard let animateSystem = target.system(ofType: AnimateSystem.self) else {
            return
        }

        animateSystem.animate(entityWith: entityID, to: key)
    }
}
