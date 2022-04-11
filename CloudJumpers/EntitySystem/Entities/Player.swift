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

        manager.addComponent(CameraAnchorTag(), to: self)
        manager.addComponent(PlayerTag(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: texture.idle,
            size: Constants.playerSize,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = SpriteZPosition.player.rawValue
        createNameLabel(for: spriteComponent)

        return spriteComponent
    }

    private func createNameLabel(for spriteComponent: SpriteComponent) {
        var displayname = name
        if displayname.count > Constants.playerDisplaynameSize {
            let index = displayname.index(displayname.startIndex, offsetBy: Constants.playerDisplaynameSize)
            displayname = displayname[..<index] + "..."
        }

        let labelNode = SKLabelNode(fontNamed: "AvenirNext-Bold")
        labelNode.text = displayname
        labelNode.fontSize = Constants.nameLabelFontSize
        labelNode.position = Constants.nameLabelRelativePosition
        labelNode.fontColor = .red

        spriteComponent.node.addChild(labelNode)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.playerSize, for: spriteComponent)
        physicsComponent.body.affectedByGravity = true
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskPlayer
        physicsComponent.body.collisionBitMask = .max ^ Constants.bitmaskGuest ^
            Constants.bitmaskShadowGuest ^ Constants.bitmaskPowerUp
        physicsComponent.body.contactTestBitMask = .max ^ Constants.bitmaskGuest
        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }
}
