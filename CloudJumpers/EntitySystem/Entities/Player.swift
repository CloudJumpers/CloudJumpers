//
//  Player.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation
import CoreGraphics

class Player: Entity {
    let id: EntityID

    private let position: CGPoint
    private let texture: Textures

    init(at position: CGPoint, texture: Textures, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.texture = texture
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)
        let animationComponent = createAnimationComponent()
        let inventoryComponent = createInventoryComponent()

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(animationComponent, to: self)
        manager.addComponent(inventoryComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let size = CGConverter.sharedConverter.getSceneSize(for: SizeConstants.playerSize)

        let spriteComponent = SpriteComponent(
            texture: texture.idle,
            size: size,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = DepthPosition.player.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let size = CGConverter.sharedConverter.getSceneSize(for: SizeConstants.playerSize)

        let physicsComponent = PhysicsComponent(rectangleOf: size, for: spriteComponent)
        physicsComponent.body.affectedByGravity = true
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = MiscConstants.bitmaskPlayer

        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }

    private func createInventoryComponent() -> InventoryComponent {
        InventoryComponent()
    }
}
