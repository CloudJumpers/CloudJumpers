//
//  PowerUp.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 25/3/22.
//

import SpriteKit
import CoreGraphics

class PowerUp: Entity {
    let id: EntityID
    let type: PowerUpType
    let name: String

    private let position: CGPoint

    init(at position: CGPoint, with id: EntityID, type: PowerUpType, name: String) {
        self.id = id
        self.type = type
        self.name = name
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: SKTexture(imageNamed: name),
            size: Constants.powerUpNodeSize,
            at: position,
            forEntityWith: id
        )

        spriteComponent.node.zPosition = SpriteZPosition.button.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(circleOf: Constants.powerUpNodeSize.width / 3, for: spriteComponent)
        physicsComponent.body.mass = 0
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.isDynamic = true
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = getBitmask()
        physicsComponent.body.contactTestBitMask = Constants.bitmaskPlayer

        return physicsComponent
    }

    private func getBitmask() -> UInt32 {
        switch type {
        case .freeze:
            return Constants.bitmaskFreezePowerUp
        case .confuse:
            return Constants.bitmaskConfusePowerUp
        }
    }
}
