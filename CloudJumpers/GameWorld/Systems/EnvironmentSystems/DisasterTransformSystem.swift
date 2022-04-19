//
//  DisasterTransformSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class DisasterTransformSystem: System {
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

        for disasterTransformComponent in manager.components(ofType: DisasterTransformComponent.self) {
            guard let disasterPrompt = disasterTransformComponent.entity,
                  let timedComponent = manager.component(ofType: TimedComponent.self, of: disasterPrompt),
                  let spriteComponent = manager.component(ofType: SpriteComponent.self, of: disasterPrompt)
            else {
                continue
            }

            if timedComponent.time >= disasterTransformComponent.timeToTransform {
                manager.remove(disasterPrompt)
                manager.add(Disaster(
                    disasterTransformComponent.kind,
                    at: disasterTransformComponent.position,
                    velocity: disasterTransformComponent.velocity,
                    texture: disasterTransformComponent.disasterTexture,
                    alpha: spriteComponent.alpha,
                    with: disasterPrompt.id + Constants.Disasters.disasterIdSuffix))
            }

        }
    }
}
