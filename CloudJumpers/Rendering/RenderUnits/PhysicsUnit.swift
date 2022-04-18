//
//  PhysicsUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

import RenderCore

class PhysicsUnit: RenderUnit {
    unowned var target: Simulatable?

    required init(on target: Simulatable?) {
        self.target = target
    }

    func transform(_ entity: Entity, with node: Node) {
        guard let physicsComponent = target?.component(ofType: PhysicsComponent.self, of: entity),
              !physicsComponent.impulse.isZero
        else { return }

        node.physicsBody?.applyImpulse(physicsComponent.impulse)
    }

    func createPhysicsBody(for entity: Entity) -> PhysicsBody? {
        guard let physicsComponent = target?.component(ofType: PhysicsComponent.self, of: entity),
              let body = Self.physicsBody(with: physicsComponent)
        else { return nil }

        Self.configurePhysicsBody(body, with: physicsComponent)
        return body
    }

    private static func configurePhysicsBody(_ body: PhysicsBody, with physicsComponent: PhysicsComponent) {
        if let mass = physicsComponent.mass {
            body.mass = mass
        }

        body.velocity = physicsComponent.velocity
        body.isDynamic = physicsComponent.isDynamic
        body.affectedByGravity = physicsComponent.affectedByGravity
        body.allowsRotation = physicsComponent.allowsRotation
        body.restitution = physicsComponent.restitution
        body.linearDamping = physicsComponent.linearDamping
        body.categoryBitMask = physicsComponent.categoryBitMask
        body.collisionBitMask = physicsComponent.collisionBitMask
        body.contactTestBitMask = physicsComponent.contactTestBitMask
    }

    private static func physicsBody(with physicsComponent: PhysicsComponent) -> PhysicsBody? {
        if physicsComponent.shape == .circle {
            return circlePhysicsBody(with: physicsComponent)
        }

        if physicsComponent.shape == .rectangle {
            return rectanglePhysicsBody(with: physicsComponent)
        }

        return nil
    }

    private static func circlePhysicsBody(with physicsComponent: PhysicsComponent) -> PhysicsBody? {
        guard let radius = physicsComponent.radius else {
            fatalError("Circle PhysicsComponent does not have a radius")
        }

        return PhysicsBody(circleOf: radius)
    }

    private static func rectanglePhysicsBody(with physicsComponent: PhysicsComponent) -> PhysicsBody? {
        guard let size = physicsComponent.size else {
            fatalError("Rectangle PhysicsComponent does not have a size")
        }

        return PhysicsBody(rectangleOf: size)
    }
}
