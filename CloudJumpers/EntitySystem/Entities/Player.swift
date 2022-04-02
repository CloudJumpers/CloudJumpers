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
    private let isGuest: Bool

    init(
        at position: CGPoint,
        texture: Textures,
        with id: EntityID = EntityManager.newEntityID,
        isCameraAnchor: Bool = false,
        isGuest: Bool = false
    ) {
        self.id = id
        self.texture = texture
        self.position = position
        self.isCameraAnchor = isCameraAnchor
        self.isGuest = isGuest
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
        let guestCollisionBitmask = .max ^ Constants.bitmaskCloud ^
        Constants.bitmaskPlayer ^
        Constants.bitmaskGuest ^ Constants.bitmaskPlatform
        physicsComponent.body.affectedByGravity = !isGuest
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = isGuest ? Constants.bitmaskGuest : Constants.bitmaskPlayer
        physicsComponent.body.collisionBitMask = isGuest ? guestCollisionBitmask: .max ^
        Constants.bitmaskGuest
        physicsComponent.body.contactTestBitMask = isGuest ? guestCollisionBitmask: .max ^
        Constants.bitmaskGuest
        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }
}
