//
//  HUDSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 18/4/22.
//

import CoreGraphics

class HUDSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        for hudComponent in manager?.components(ofType: HUDComponent.self) ?? [] {
            guard let hud = hudComponent.entity,
                  let spriteComponent = manager?.component(ofType: SpriteComponent.self, of: hud),
                  let player = manager?.components(ofType: PlayerTag.self).first?.entity,
                  let platform = manager?.components(ofType: TopPlatformTag.self).first?.entity,
                  let playerPositionComponent = manager?.component(ofType: PositionComponent.self, of: player),
                  let platformPositionComponent = manager?.component(ofType: PositionComponent.self, of: platform)
            else { continue }

            let playerLevel = playerPositionComponent.position.y
            let platformLevel = platformPositionComponent.position.y

            guard let distanceToCompletion = hudComponent.distanceToCompletion else {
                hudComponent.distanceToCompletion = platformLevel - playerLevel
                continue
            }

            let currentDistance = platformLevel - playerLevel
            let progress = (currentDistance / distanceToCompletion) * 10
            let progressInt = Int(10 - min(max(0, progress), 10))

            spriteComponent.texture = HUDs.forProgress(progressInt).frame
        }
    }
}
