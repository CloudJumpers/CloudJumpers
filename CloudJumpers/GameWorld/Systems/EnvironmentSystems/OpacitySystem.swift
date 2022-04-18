//
//  OpacitySystem.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 18/4/22.
//

import Foundation

class OpacitySystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func modifyAlpha(_ entityID: EntityID, alpha: Double) {
        guard (Double.zero ... 1.0).contains(alpha),
              let spriteComponent = manager?.component(ofType: SpriteComponent.self, of: entityID)
        else { return }

        spriteComponent.alpha = alpha
    }
}
