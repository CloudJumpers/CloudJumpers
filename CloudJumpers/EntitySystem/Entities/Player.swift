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
        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)

        manager.addComponent(AnimationComponent(), to: self)
        manager.addComponent(InventoryComponent(), to: self)
        manager.addComponent(CameraAnchorTag(), to: self)
        manager.addComponent(PlayerTag(), to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        SpriteComponent(texture: texture.idle, size: Constants.playerSize, zPosition: .player)
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
}
