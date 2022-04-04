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

    init(_ kind: PowerUpComponent.Kind, at position: CGPoint, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.kind = kind
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
        let spriteComponent = SpriteComponent(
            texture: SKTexture(imageNamed: kind.name),
            size: Constants.powerUpNodeSize,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = SpriteZPosition.powerUp.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(
            circleOf: Constants.powerUpNodeSize.width / 2,
            for: spriteComponent)

        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskPowerUp
        physicsComponent.body.collisionBitMask = 0
        physicsComponent.body.contactTestBitMask = Constants.bitmaskPlayer

        return physicsComponent
    }

}
