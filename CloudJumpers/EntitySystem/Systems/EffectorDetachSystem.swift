//
//  EffectorDetachSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class EffectorDetachSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    var positionGenerationInfo: RandomPositionGenerationInfo?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {}

    func shouldDetach(watchingEntity effectEntity: Entity) -> Bool {
        guard let manager = manager,
              let timerComponent = manager.component(ofType: TimedComponent.self, of: effectEntity) else {
            return false
        }

        return timerComponent.time >= Constants.powerUpEffectDuration
    }
}
