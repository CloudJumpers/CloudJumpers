//
//  SpriteSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

// class SpriteSystem {
//    // MARK: - Per-component Updates
//    func updateTimed(of node: SKNode, with entity: Entity) {
//        // TODO: Generalise this to support more than just SKLabelNode
//        guard let timedComponent = manager?.component(ofType: TimedComponent.self, of: entity),
//              let labelNode = node as? SKLabelNode
//        else { return }
//
//        labelNode.text = String(format: "%.1f", timedComponent.time)
//    }
//
//    func updateAnimation(of node: SKNode, with entity: Entity) {
//        guard let animationComponent = manager?.component(ofType: AnimationComponent.self, of: entity) else {
//            return
//        }
//
//        let texture = animationComponent.texture.of(animationComponent.kind)
//
//        if node.action(forKey: animationComponent.kind.name) == nil {
//
//            for actionKey in Textures.Kind.allCases {
//                node.removeAction(forKey: actionKey.name)
//            }
//            node.run(.repeatForever(.animate(
//                with: texture,
//                timePerFrame: 0.1,
//                resize: false,
//                restore: true)),
//            withKey: animationComponent.kind.name)
//        }
//    }
// }
