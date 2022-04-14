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
    private let texture: Textures

    init(
        at position: CGPoint,
        texture: Textures,
        name: String,
        with id: EntityID = EntityManager.newEntityID
    ) {
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
        let spriteComponent = SpriteComponent(
            texture: texture.idle,
            size: Constants.playerSize,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = SpriteZPosition.guest.rawValue
        createNameLabel(for: spriteComponent)

        return spriteComponent
    }

    private func createNameLabel(for spriteComponent: SpriteComponent) {
        var displayname = name
        if displayname.count > Constants.playerDisplaynameSize {
            let index = displayname.index(displayname.startIndex, offsetBy: Constants.playerDisplaynameSize)
            displayname = displayname[..<index] + "..."
        }

        let labelNode = SKLabelNode()
        labelNode.text = displayname
        labelNode.fontSize = Constants.captionFontSize
        labelNode.position = Constants.captionRelativePosition
        labelNode.fontColor = .black

        spriteComponent.node.addChild(labelNode)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.playerSize)
        let guestCollisionBitmask = .max ^ Constants.bitmaskPlayer ^ Constants.bitmaskShadowGuest ^
        Constants.bitmaskGuest ^ Constants.bitmaskPlatform ^ Constants.bitmaskDisaster ^ Constants.bitmaskPowerUp
        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.categoryBitMask = Constants.bitmaskGuest
        physicsComponent.collisionBitMask = guestCollisionBitmask ^ Constants.bitmaskCloud
        physicsComponent.contactTestBitMask = guestCollisionBitmask
        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }
}
