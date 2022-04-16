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
    private let texture: Clouds

    init(at position: CGPoint, texture: Clouds, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.texture = texture
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(PositionComponent(at: position), to: self)
        manager.addComponent(TopPlatformTag(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.frame, size: Constants.platformNodeSize, zPosition: .platform)
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
