//
//  Meteor.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//

import Foundation
import SpriteKit

class Meteor: Entity {
    let id: EntityID

    private let position: CGPoint
    private let velocity: CGVector

    init(at position: CGPoint, velocity: CGVector,
         with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.position = position
        self.velocity = velocity
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let node = SKSpriteNode(
            texture: SKTexture(imageNamed: "meteor"),
            size: Constants.disasterSize)

        node.position = position
        node.zRotation = getRotationAngle()
        node.zPosition = SpriteZPosition.powerUp.rawValue

        return SpriteComponent(node: node, forEntityWith: id)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.disasterSize,
                                                for: spriteComponent)
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.velocity = self.velocity
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskDisaster
        physicsComponent.body.collisionBitMask =
        Constants.bitmaskCloud | Constants.bitmaskPlayer | Constants.bitmaskPlatform

        return physicsComponent
    }

    private func getRotationAngle() -> CGFloat {
        -atan(velocity.dx / velocity.dy)
    }
}
