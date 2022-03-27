//
//  SpriteSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteSystem: System {
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for entity in manager.iterableEntities {
            guard let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity) else {
                continue
            }

            let node = spriteComponent.node
            updateAnimation(of: node, with: entity)
            updateTimed(of: node, with: entity)
        }
    }

    func updateTimed(of node: SKNode, with entity: Entity) {
        // TODO: Generalise this to support more than just SKLabelNode
        guard let timedComponent = manager?.component(ofType: TimedComponent.self, of: entity),
              let labelNode = node as? SKLabelNode
        else { return }

        labelNode.text = String(format: "%.1f", timedComponent.time)
    }

    func updateAnimation(of node: SKNode, with entity: Entity) {
        guard let animationComponent = manager?.component(ofType: AnimationComponent.self, of: entity) else {
            return
        }

        let texture = animationComponent.texture.of(animationComponent.kind)

        if node.action(forKey: animationComponent.kind.name) == nil {
            node.run(.repeatForever(.animate(
                with: texture,
                timePerFrame: 0.1,
                resize: false,
                restore: true)),
            withKey: animationComponent.kind.name)
        }
    }
}
