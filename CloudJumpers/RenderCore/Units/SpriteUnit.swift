//
//  SpriteUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

class SpriteUnit: RenderUnit {
    unowned var target: Simulatable?

    required init(on target: Simulatable?) {
        self.target = target
    }

    func createSpriteNode(for entity: Entity) -> SpriteNode? {
        guard let spriteComponent = target?.component(ofType: SpriteComponent.self, of: entity),
              let positionComponent = target?.component(ofType: PositionComponent.self, of: entity)
        else { return nil }

        let node = SpriteNode(texture: spriteComponent.texture, size: spriteComponent.size)
        node.position = positionComponent.position
        node.name = entity.id

        Self.configureSpriteNode(node, with: spriteComponent)
        return node
    }

    private static func configureSpriteNode(_ node: SpriteNode, with spriteComponent: SpriteComponent) {
        node.zPosition = spriteComponent.zPosition.rawValue
        node.alpha = spriteComponent.alpha
        node.zRotation = spriteComponent.zRotation
        // TODO: Add node.anchorPoint = spriteComponent.anchorPoint here
    }
}
