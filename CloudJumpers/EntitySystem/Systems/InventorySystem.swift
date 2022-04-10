//
//  InventorySystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics


class InventorySystem: System {
    var active: Bool
    
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }
    
    func update(within time: CGFloat) {
        guard let manager = manager,
              let entity = manager.getEntities().first(where: {manager.hasComponent(ofType: PlayerTag.self, in: $0)}),
              let inventoryComponent = manager.component(ofType: InventoryComponent.self, of: entity),
              inventoryComponent.inventory.isUpdated else {
            return
        }

        inventoryComponent.inventory.isUpdated = false
        var position = Constants.initialPowerUpQueuePosition
        var displayCount = 0

        for entityID in inventoryComponent.inventory.iterable {
            guard let entity = manager.entity(with: entityID),
                  let spriteComponent = manager.component(ofType: SpriteComponent.self, of: entity),
                  let ownerComponent = manager.component(ofType: OwnerComponent.self, of: entity),
                  ownerComponent.ownerEntityId != nil
            else { continue }

            guard displayCount <= Constants.powerUpMaxNumDisplay else {
                break
            }

            displayCount += 1
            
            // TODO: Figure this out ???

            spriteComponent.node.removeFromParent()

            spriteComponent.node.position = position
            spriteComponent.node.physicsBody = nil

            position.x += Constants.powerUpQueueXInterval
        }
    }
    
    
}
