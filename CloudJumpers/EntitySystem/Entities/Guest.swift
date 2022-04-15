//
//  Guest.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/3/22.
//

import Foundation
import CoreGraphics
import SpriteKit

class Guest: Entity {
    let id: EntityID

    private(set) var position: CGPoint
    private let name: String
    private let texture: Characters

    init(at position: CGPoint, texture: Characters, name: String, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.texture = texture
        self.name = name
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)
        let animationComponent = createAnimationComponent()

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(animationComponent, to: self)
        manager.addComponent(InventoryComponent(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.idle, size: Constants.playerSize, zPosition: .guest)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.playerSize)

        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.categoryBitMask = PhysicsCategory.guest
        physicsComponent.collisionBitMask = PhysicsCollision.guest
        physicsComponent.contactTestBitMask = PhysicsContactTest.guest

        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        let animationComponent = AnimationComponent()
        animationComponent.animations[CharacterFrames.idle.key] = texture.idle.asFrames
        animationComponent.animations[CharacterFrames.jumping.key] = texture.jumping
        animationComponent.animations[CharacterFrames.walking.key] = texture.walking
        animationComponent.animations[CharacterFrames.prejump.key] = texture.prejumping
        return animationComponent
    }
}
