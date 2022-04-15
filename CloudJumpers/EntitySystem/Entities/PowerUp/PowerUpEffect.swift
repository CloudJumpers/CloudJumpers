//
//  PowerUpEffect.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import Foundation
import CoreGraphics

class PowerUpEffect: Entity {
    let id: EntityID

    private let position: CGPoint
    private let texture: Miscellaneous
    private let intervalToRemove: TimeInterval
    private let activatorId: EntityID
    private let powerUpComponent: PowerUpEffectComponent

    init(
        at position: CGPoint,
        removeAfter intervalToRemove: TimeInterval,
        activatorId: EntityID,
        texture: Miscellaneous,
        powerUpComponent: PowerUpEffectComponent,
        with id: EntityID = EntityManager.newEntityID
    ) {
        self.id = id
        self.position = position
        self.activatorId = activatorId
        self.texture = texture
        self.powerUpComponent = powerUpComponent
        self.intervalToRemove = intervalToRemove
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(TimedRemovalComponent(timeToRemove: intervalToRemove), to: self)
        manager.addComponent(TimedComponent(), to: self)
        manager.addComponent(powerUpComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.frame, size: Constants.powerUpEffectSize, zPosition: .powerUpEffect)
    }
}
