//
//  Wall.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//
import SpriteKit

class Wall: Entity {
    let id: EntityID

    private let position: CGPoint
    private let height: CGFloat
    private let texture: Miscellaneous

    var wallSize: CGSize {
        CGSize(width: Constants.wallWidth, height: height)
    }

    init(at position: CGPoint, height: CGFloat, texture: Miscellaneous, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.position = position
        self.height = height
        self.texture = texture
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(PositionComponent(at: position), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.frame, size: wallSize, zPosition: .wall)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: wallSize)
        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsCategory.wall
        physicsComponent.collisionBitMask = PhysicsCollision.wall
        physicsComponent.contactTestBitMask = PhysicsContactTest.wall

        return physicsComponent
    }
}
