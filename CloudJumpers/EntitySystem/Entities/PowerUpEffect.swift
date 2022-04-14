//
//  PowerUpEffect.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import SpriteKit

class PowerUpEffect: Entity {
    let id: EntityID

    private var position: CGPoint
    private var kind: PowerUpComponent.Kind
    private var texture: Miscellaneous
    private let intervalToRemove: TimeInterval

    init(
        _ kind: PowerUpComponent.Kind,
        at position: CGPoint,
        texture: Miscellaneous,
        removeAfter intervalToRemove: TimeInterval,
        with id: EntityID = EntityManager.newEntityID
    ) {
        self.id = id
        self.kind = kind
        self.texture = texture
        self.position = position
        self.intervalToRemove = intervalToRemove
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        manager.addComponent(spriteComponent, to: self)

        manager.addComponent(TimedRemovalComponent(timeToRemove: intervalToRemove), to: self)
        manager.addComponent(TimedComponent(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.frame, size: Constants.powerUpEffectSize, zPosition: .powerUpEffect)
    }
}
