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
    private let texture: Miscellaneous

    init(
        _ kind: DisasterComponent.Kind,
        at position: CGPoint,
        velocity: CGVector,
        texture: Miscellaneous,
        with id: EntityID = EntityManager.newEntityID
    ) {
        self.id = id
        self.kind = kind
        self.position = position
        self.texture = texture
        self.velocity = velocity
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)
        let removeOutOfBoundTag = RemoveOutOfBoundTag()

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
        manager.addComponent(removeOutOfBoundTag, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        let spriteComponent = SpriteComponent(texture: texture.frame, size: Constants.disasterNodeSize, zPosition: .disaster)
        spriteComponent.zRotation = Self.rotation(of: velocity)
        spriteComponent.anchorPoint = CGPoint(x: 0.5, y: 0)

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.disasterPhysicsSize)

        physicsComponent.affectedByGravity = false
        physicsComponent.mass = Constants.disasterMass
        physicsComponent.velocity = velocity
        physicsComponent.allowsRotation = false
        physicsComponent.categoryBitMask = PhysicsCategory.disaster
        physicsComponent.linearDamping = 0.0
        physicsComponent.collisionBitMask = PhysicsCollision.disaster
        physicsComponent.contactTestBitMask = PhysicsContactTest.disaster

        return physicsComponent
    }

    private static func rotation(of vector: CGVector) -> CGFloat {
        -atan(vector.dx / vector.dy)
    }
}
