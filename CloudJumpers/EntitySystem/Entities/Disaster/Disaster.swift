//
//  Disaster.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//

import SpriteKit

class Disaster: Entity {
    let id: EntityID

    private var associatedEntity: Entity
    private var position: CGPoint = Constants.defaultPosition
    private var velocity: CGVector = Constants.defaultVelocity
    private(set) var type: DisasterType = .meteor

    init(for entity: Entity,
         with id: EntityID = EntityManager.newEntityID) {

        self.id = id
        self.associatedEntity = entity
        self.position = getRandomPosition()
        self.velocity = getRandomVelocity()
        self.type = getRandomType()
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let node = SKSpriteNode(
            texture: SKTexture(imageNamed: "\(type)"),
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

    private func getRandomVelocity() -> CGVector {
        let xDir = getRandomDouble(from: -1, to: 1)
        let yDir = getRandomDouble(from: -1, to: 0)
        let velocity = getRandomDouble(from: 80, to: 150)

        return velocity * CGVector(dx: xDir, dy: yDir).normalized()
    }

    private func getRandomPosition() -> CGPoint {
        var disasterPosition = CGPoint(x: 0.0, y: 0.0)
        if let player = associatedEntity as? Player {
            disasterPosition.x = getRandomDouble(from: -350, to: 350)
            let minY = player.position.y + 300
            let maxY = player.position.y + 800
            disasterPosition.y = getRandomDouble(from: minY, to: maxY)
        }

        return disasterPosition
    }

    private func getRandomDouble(from: Double, to: Double) -> Double {
        Double.random(in: from...to)
    }

    private func getRandomType() -> DisasterType {
        .meteor
    }
}
