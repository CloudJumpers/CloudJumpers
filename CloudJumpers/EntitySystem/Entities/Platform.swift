//
//  Platform.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class Platform: Entity {
    let id: EntityID

    private let position: CGPoint

    init(at position: CGPoint, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.position = position
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
        let size = CGConverter.sharedConverter.getSceneSize(for: SizeConstants.platformNodeSize)

        let spriteComponent = SpriteComponent(
            texture: texture,
            size: size,
            at: position,
            forEntityWith: id)

        spriteComponent.node.zPosition = DepthPosition.platform.rawValue

        return spriteComponent
    }

    private func createPhysicsComponent(for spriteComponent: SpriteComponent) -> PhysicsComponent {
        let size = CGConverter.sharedConverter.getSceneSize(for: SizeConstants.platformPhysicsSize)

        let physicsComponent = PhysicsComponent(rectangleOf: size, for: spriteComponent)
        physicsComponent.body.affectedByGravity = false
        physicsComponent.body.allowsRotation = false
        physicsComponent.body.isDynamic = false
        physicsComponent.body.restitution = 0
        physicsComponent.body.categoryBitMask = MiscConstants.bitmaskPlatform
        physicsComponent.body.contactTestBitMask = MiscConstants.bitmaskPlayer

        return physicsComponent
    }
}
