//
//  PowerUp.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import SpriteKit

class PowerUp: Entity {
    let id: EntityID

    private let position: CGPoint
    private let kind: PowerUpComponent.Kind
    private let texture: Miscellaneous

    init(
        _ kind: PowerUpComponent.Kind,
        at position: CGPoint,
        with id: EntityID = EntityManager.newEntityID
    ) {
        self.id = id
        self.kind = kind
        self.texture = Miscellaneous(rawValue: kind.rawValue) ?? .freeze
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(OwnerComponent(), to: self)
        manager.addComponent(PowerUpComponent(kind), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.frame, size: Constants.powerUpNodeSize, zPosition: .powerUp)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(
            circleOf: Constants.powerUpNodeSize.width / 2,
            for: spriteComponent)

        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.categoryBitMask = PhysicsCategory.powerUp
        physicsComponent.collisionBitMask = PhysicsCollision.powerUp
        physicsComponent.contactTestBitMask = PhysicsContactTest.powerUp

        return physicsComponent
    }

}
