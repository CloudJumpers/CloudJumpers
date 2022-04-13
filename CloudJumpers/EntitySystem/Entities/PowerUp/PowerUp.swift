//
//  PowerUp.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 26/3/22.
//

import CoreGraphics

protocol PowerUp: Entity {
    var position: CGPoint { get }
    var kind: PowerUpComponent.Kind { get }

    func activate(on entity: Entity, watching watchingEntity: Entity) -> Event?

    func isAffectingLocation(location: CGPoint) -> Bool

    func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool
}

extension PowerUp {
    func isAffectingLocation(location: CGPoint) -> Bool {
        false
    }

    func canAffectEntity(activatorEntityId: EntityID, targetEntityId: EntityID) -> Bool {
        activatorEntityId != targetEntityId
    }
}

extension PowerUp {
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
