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

    init(with id: EntityID?, at position: CGPoint, texture: Textures) {
        self.id = id ?? UUID().uuidString
        self.texture = texture
        self.position = position
    }

    convenience init(at position: CGPoint, texture: Textures) {
        self.init(with: nil, at: position, texture: texture)
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
        let spriteComponent = SpriteComponent(texture: texture.idle, size: Constants.playerSize, at: position)
        spriteComponent.node.zPosition = SpriteZPosition.player.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.playerSize, for: spriteComponent)
        physicsComponent.body.affectedByGravity = true
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskPlayer

        return physicsComponent
    }

    private func createAnimationComponent() -> AnimationComponent {
        AnimationComponent(texture: texture, kind: .idle)
    }
}
