//
//  Cloud.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import CoreGraphics

class Cloud: Entity {
    let id: EntityID

    private let position: CGPoint
    private let texture: Clouds
    private let horizontalVelocity: CGFloat

    init(at position: CGPoint, texture: Clouds,
         horizontalVelocity: CGFloat = CGFloat.zero,
         with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.texture = texture
        self.position = position
        self.horizontalVelocity = horizontalVelocity
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)

        if !horizontalVelocity.isZero {
            manager.addComponent(HorizontalOscillationComponent(at: position,
                                                                horizontalVelocity: horizontalVelocity),
                                 to: self)
        }
        manager.addComponent(PositionComponent(at: position), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.frame, size: Constants.cloudNodeSize, zPosition: .platform)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.cloudPhysicsSize)
        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.isDynamic = false
        physicsComponent.categoryBitMask = PhysicsCategory.cloud
        physicsComponent.collisionBitMask = PhysicsCollision.cloud
        physicsComponent.contactTestBitMask = PhysicsContactTest.cloud

        return physicsComponent
    }
}
