//
//  Guest.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/3/22.
//

import Foundation
import CoreGraphics

class Guest: Entity {
    let id: EntityID

    private(set) var position: CGPoint
    private let texture: Textures

    init(
        at position: CGPoint,
        texture: Textures,
        with id: EntityID = EntityManager.newEntityID
    ) {
        self.id = id
        self.texture = texture
        self.position = position
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)
        let animationComponent = createAnimationComponent()

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(animationComponent, to: self)

        // TO DO: Maybe remove this
        manager.addComponent(InventoryComponent(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: texture.idle,
            size: Constants.playerSize,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = SpriteZPosition.guest.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.playerSize, for: spriteComponent)
        let guestCollisionBitmask = .max ^ Constants.bitmaskCloud ^ Constants.bitmaskPlayer ^
        Constants.bitmaskGuest ^ Constants.bitmaskPlatform ^ Constants.bitmaskDisaster
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskGuest
        physicsComponent.body.collisionBitMask = guestCollisionBitmask
        physicsComponent.body.contactTestBitMask = guestCollisionBitmask
        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }
}
