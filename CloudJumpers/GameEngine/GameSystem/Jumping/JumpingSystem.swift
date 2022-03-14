//
//  JumpingSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 14/3/22.
//

import Foundation
import CoreGraphics
import SpriteKit

class JumpingSystem: System {
    weak var entitiesManager: EntitiesManager?

    private var entityComponentMapping: [Entity: JumpingComponent] = [:]

    init (entitiesManager: EntitiesManager) {
        self.entitiesManager = entitiesManager
    }

    func update(_ deltaTime: Double) {
        for entity in entityComponentMapping.keys {
            guard let node = entitiesManager?.getNode(of: entity),
                  entityComponentMapping[entity] != nil else {
                return
            }

            // avoid jumping in the air
            if !isJumping(node: node) {
                node.physicsBody?.applyImpulse(Constants.jumpImpulse)
            }
            entityComponentMapping.removeValue(forKey: entity)
        }
    }

    func addComponent(entity: Entity, component: Component) {
        guard let jumpingComponent = component as? JumpingComponent else {
            return
        }
        entityComponentMapping[entity] = jumpingComponent
    }

    private func isJumping(node: SKNode) -> Bool {
        abs(node.physicsBody?.velocity.dy ?? 0.0) > Constants.jumpYTolerance
    }

}
