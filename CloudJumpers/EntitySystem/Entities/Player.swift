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

    private(set) var position: CGPoint
    private let texture: Textures
    private let isCameraAnchor: Bool

    init(
        at position: CGPoint,
        texture: Textures,
        with id: EntityID = EntityManager.newEntityID,
        isCameraAnchor: Bool = false
    ) {
        self.id = id
        self.texture = texture
        self.position = position
        self.isCameraAnchor = isCameraAnchor
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)
        let animationComponent = createAnimationComponent()

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(animationComponent, to: self)
        manager.addComponent(InventoryComponent(), to: self)

        if isCameraAnchor {
            manager.addComponent(CameraAnchorTag(), to: self)
        }
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: texture.idle,
            size: Constants.playerSize,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = SpriteZPosition.player.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.playerSize, for: spriteComponent)
        physicsComponent.body.affectedByGravity = true
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskPlayer
        physicsComponent.body.collisionBitMask = 0xFFFFFFFF
        physicsComponent.body.contactTestBitMask = 0xFFFFFFFF

        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }
}
