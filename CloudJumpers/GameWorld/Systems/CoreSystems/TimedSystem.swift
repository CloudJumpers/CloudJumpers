//
//  TimedSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import CoreGraphics

class TimedSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for timedComponent in manager.components(ofType: TimedComponent.self) {
            timedComponent.time += time
        }
    }
}
