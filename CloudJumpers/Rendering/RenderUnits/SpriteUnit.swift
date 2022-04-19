//
//  SpriteUnit.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 16/4/22.
//

import RenderCore

class SpriteUnit: RenderUnit {
    unowned var target: Simulatable?

    required init(on target: Simulatable?) {
        self.target = target
    }

    func createNode(for entity: Entity) -> Node? {
        guard let spriteComponent = target?.component(ofType: SpriteComponent.self, of: entity),
              let positionComponent = target?.component(ofType: PositionComponent.self, of: entity)
        else { return nil }

        let node = SpriteNode(texture: spriteComponent.texture, size: spriteComponent.size)
        node.position = positionComponent.position
        node.name = entity.id

        Self.configureSpriteNode(node, with: spriteComponent)
        configureCaption(for: entity, with: node)
        return node
    }

    func transform(_ entity: Entity, with node: Node) {
        guard let spriteComponent = target?.component(ofType: SpriteComponent.self, of: entity),
              let spriteNode = node as? SpriteNode
        else { return }

        spriteNode.alpha = spriteComponent.alpha
        spriteNode.setTexture(to: spriteComponent.texture)
    }

    private static func configureSpriteNode(_ node: SpriteNode, with spriteComponent: SpriteComponent) {
        node.zPosition = spriteComponent.zPosition.rawValue
        node.alpha = spriteComponent.alpha
        node.zRotation = spriteComponent.zRotation
        node.anchorPoint = spriteComponent.anchorPoint
    }

    private func configureCaption(for entity: Entity, with node: SpriteNode) {
        guard let spriteComponent = target?.component(ofType: SpriteComponent.self, of: entity),
              let caption = spriteComponent.caption
        else { return }

        let isMainPlayer = target?.hasComponent(ofType: PlayerTag.self, in: entity) ?? false

        node.caption(
            caption,
            at: Positions.playerCaption,
            size: Dimensions.captionFontSize,
            typeface: Fonts.body.rawValue,
            truncateBy: Constants.captionMaxLength,
            color: isMainPlayer ? .red : .black)
    }
}
