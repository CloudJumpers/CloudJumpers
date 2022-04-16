//
//  AnimateSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class AnimateSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
    }

    func animate(entityWith id: EntityID, to key: AnimationKey) {
        guard let animationComponent = manager?.component(ofType: AnimationComponent.self, of: id),
              let animation = animationComponent.animations[key]
        else { return }

        animationComponent.activeAnimation = (key, animation)
    }
}
