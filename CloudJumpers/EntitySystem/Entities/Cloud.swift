//
//  Cloud.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

// TODO: cloud may oscille differently on different devices, to be checked
// TODO: player may not move when standing on top of moving cloud, to be checked
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

        if abs(horizontalVelocity) <= Constants.cloudMovingTolerance {
            manager.addComponent(HorizontalOscillationComponent(at: position,
                                                                horizontalVelocity: horizontalVelocity),
                                 to: self)
        }
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
