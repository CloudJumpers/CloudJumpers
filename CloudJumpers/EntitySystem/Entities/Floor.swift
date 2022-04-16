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
    private let texture: Miscellaneous

    init(at position: CGPoint, texture: Miscellaneous, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.texture = texture
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.frame, size: Constants.floorSize, zPosition: .floor)
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
