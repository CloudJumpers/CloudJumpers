//
//  Player.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation
import CoreGraphics
import SpriteKit

class Player: Entity {
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
        manager.addComponent(PositionComponent(at: position), to: self)
        manager.addComponent(StandOnComponent(), to: self)

        manager.addComponent(InventoryComponent(), to: self)
        manager.addComponent(CameraAnchorTag(), to: self)
        manager.addComponent(PlayerTag(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: texture.idle,
            size: Constants.playerSize,
            zPosition: .player)

        spriteComponent.caption = name

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.playerSize)
        physicsComponent.affectedByGravity = true
        physicsComponent.allowsRotation = false
        physicsComponent.categoryBitMask = PhysicsCategory.player
        physicsComponent.collisionBitMask = PhysicsCollision.player
        physicsComponent.contactTestBitMask = PhysicsContactTest.player
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
