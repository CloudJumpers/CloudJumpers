//
//  Platform.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class Platform: Entity {
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
        manager.addComponent(TopPlatformTag(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        // TODO: Abstract out Clouds texture atlas
        let texture = SKTextureAtlas(named: "EndPlatform").textureNamed("cloud-1")
        let spriteComponent = SpriteComponent(
            texture: texture,
            size: Constants.platformNodeSize,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = SpriteZPosition.platform.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.platformPhysicsSize)
        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsCategory.platform
        physicsComponent.collisionBitMask = PhysicsCollision.platform
        physicsComponent.contactTestBitMask = PhysicsContactTest.platform

        return physicsComponent
    }
}
