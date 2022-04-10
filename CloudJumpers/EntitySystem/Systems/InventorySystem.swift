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
              let entity = manager.getEntities().first(where: { manager.hasComponent(ofType: PlayerTag.self, in: $0) }),
              let inventoryComponent = manager.component(ofType: InventoryComponent.self, of: entity),
              inventoryComponent.inventory.isUpdated else {
            return
        }

        inventoryComponent.inventory.isUpdated = false
        var position = Constants.initialPowerUpQueuePosition
        var displayCount = 0

        for entityID in inventoryComponent.inventory.iterable {
            guard let entity = manager.entity(with: entityID)
            else { continue }

            guard displayCount <= Constants.powerUpMaxNumDisplay else {
                break
            }

            displayCount += 1

            // TODO: Move the position of PowerUp inside inventory

//            spriteComponent.node.removeFromParent()
//            spriteComponent.node.position = position
//            spriteComponent.node.physicsBody = nil
//            delegate?.spriteSystem(self, addNode: spriteComponent.node, static: true)

            position.x += Constants.powerUpQueueXInterval
        }
    }

    func dequeueItem(for id: EntityID) -> EntityID? {
        guard let entity = manager?.entity(with: id),
              let inventoryComponent = manager?.component(ofType: InventoryComponent.self, of: entity)
        else { return nil }
        return inventoryComponent.inventory.dequeue()

    }

    func enqueueItem(for id: EntityID, with powerUpId: EntityID) {
        guard let entity = manager?.entity(with: id),
              let inventoryComponent = manager?.component(ofType: InventoryComponent.self, of: entity)
        else { return }

        inventoryComponent.inventory.enqueue(powerUpId)
    }

}
