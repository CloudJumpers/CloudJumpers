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
            texture: SKTexture(imageNamed: "wall_1080x50"),
            size: Constants.floorSize,
            at: position,
            forEntityWith: id
        )

        spriteComponent.node.zPosition = SpriteZPosition.wall.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.floorSize, for: spriteComponent)
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.isDynamic = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskWall
        physicsComponent.body.contactTestBitMask = Constants.bitmaskPlayer | Constants.bitmaskDisaster

        return physicsComponent
    }
}
