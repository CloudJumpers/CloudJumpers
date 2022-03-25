//
//  Cloud.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class Cloud: Entity {
    let id: EntityID

    private let position: CGPoint

    init(with id: EntityID?, at position: CGPoint) {
        self.id = id ?? UUID().uuidString
        self.position = position
    }

    convenience init(at position: CGPoint) {
        self.init(with: nil, at: position)
    }

    func setUpAndAdd(to manager: EntityManager) {
        let spriteComponent = createSpriteComponent()
        let physicsComponent = createPhysicsComponent(for: spriteComponent)

        manager.addComponent(spriteComponent, to: self)
        manager.addComponent(physicsComponent, to: self)
    }

    private func createSpriteComponent() -> SpriteComponent {
        // TODO: Abstract out Clouds texture atlas
        let texture = SKTextureAtlas(named: "Clouds").textureNamed("cloud-1")
        let spriteComponent = SpriteComponent(texture: texture, size: Constants.cloudNodeSize, at: position)
        spriteComponent.node.zPosition = SpriteZPosition.platform.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let physicsComponent = PhysicsComponent(rectangleOf: Constants.cloudPhysicsSize, for: spriteComponent)
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.isDynamic = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = Constants.bitmaskCloud
        physicsComponent.body.contactTestBitMask = Constants.bitmaskPlayer

        return physicsComponent
    }
}
