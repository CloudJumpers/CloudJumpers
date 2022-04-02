//
//  Disaster.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//
import SpriteKit

class Disaster: Entity {
    let id: EntityID
    private var position: CGPoint
    private var velocity: CGVector
    private let kind: DisasterComponent.Kind

    init(_ kind: DisasterComponent.Kind, at position: CGPoint, velocity: CGVector,
         with id: EntityID = EntityManager.newEntityID) {

        self.id = id
        self.kind = kind
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
            texture: SKTexture(imageNamed: "\(kind)"),
            size: Constants.disasterNodeSize)

        node.position = position
        node.zRotation = getRotationAngle()
        node.zPosition = SpriteZPosition.disaster.rawValue
        node.anchorPoint = CGPoint(x: 0.5, y: 0)

        return SpriteComponent(node: node, forEntityWith: id)
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.disasterPhysicsSize,
                                                for: spriteComponent)
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.velocity = self.velocity
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskDisaster
        physicsComponent.body.collisionBitMask =
        Constants.bitmaskCloud | Constants.bitmaskPlayer | Constants.bitmaskGuest |
        Constants.bitmaskPlatform | Constants.bitmaskFloor
        physicsComponent.body.contactTestBitMask =
        Constants.bitmaskCloud | Constants.bitmaskPlayer | Constants.bitmaskGuest |
        Constants.bitmaskPlatform | Constants.bitmaskFloor

        return physicsComponent
    }

    private func getRotationAngle() -> CGFloat {
        -atan(velocity.dx / velocity.dy)
    }
}
