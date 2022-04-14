//
//  Floor.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//
import SpriteKit

class Floor: Entity {
    let id: EntityID

    private let position: CGPoint

    init(at position: CGPoint, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
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
            texture: SKTexture(imageNamed: "floor"),
            size: Constants.floorSize,
            at: position,
            forEntityWith: id
        )

        spriteComponent.node.zPosition = SpriteZPosition.floor.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.floorSize)
        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsCategory.floor
        physicsComponent.collisionBitMask = PhysicsCollision.floor
        physicsComponent.contactTestBitMask = PhysicsContactTest.floor

        return physicsComponent
    }
}
