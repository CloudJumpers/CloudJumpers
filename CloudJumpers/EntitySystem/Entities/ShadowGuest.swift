//
//  ShadowGuest.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 10/4/22.
//

import Foundation
import CoreGraphics
import SpriteKit

class ShadowGuest: Entity {
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
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(
            texture: texture.idle,
            size: Constants.playerSize,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = SpriteZPosition.shadowGuest.rawValue
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

        physicsComponent.affectedByGravity = false
        physicsComponent.allowsRotation = false
        physicsComponent.categoryBitMask = PhysicsCategory.shadowGuest
        physicsComponent.collisionBitMask = PhysicsCollision.shadowGuest
        physicsComponent.contactTestBitMask = PhysicsContactTest.shadowGuest
        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }
}
