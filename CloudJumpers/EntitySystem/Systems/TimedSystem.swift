//
//  TimedSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 24/3/22.
//

import SpriteKit

class TimedSystem: System {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for timedComponent in manager.components(ofType: TimedComponent.self) {
            print(timedComponent.entity?.id)
            timedComponent.time += time
        }
    }
}
