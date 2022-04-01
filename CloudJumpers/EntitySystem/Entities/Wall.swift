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

    var wallSize: CGSize {
        CGSize(width: Constants.wallWidth, height: height)
    }

    init(at position: CGPoint, height: CGFloat,
         with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.position = position
        self.height = height
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        // TODO: Abstract out Clouds texture atlas
        let spriteComponent = SpriteComponent(
            texture: SKTexture(imageNamed: "wall"),
            size: wallSize,
            at: position,
            forEntityWith: id
        )

        spriteComponent.node.zPosition = SpriteZPosition.wall.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: wallSize, for: spriteComponent)
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.isDynamic = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskWall
        physicsComponent.body.collisionBitMask = Constants.bitmaskPlayer
        physicsComponent.body.contactTestBitMask = Constants.bitmaskPlayer

        return physicsComponent
    }
}
