//
//  InventorySystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class InventorySystem: System {
    var active = true

    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for entity in manager.entities {
            guard let inventoryComponent = manager.component(ofType: InventoryComponent.self, of: entity),
                  inventoryComponent.inventory.isUpdated else {
                continue
            }
            inventoryComponent.inventory.isUpdated = false

            if manager.hasComponent(ofType: PlayerTag.self, in: entity) {
                updatePlayerInventory(inventoryComponent)
            } else {
                updateGuestInventory(inventoryComponent)
            }
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

    private func updatePlayerInventory(_ inventoryComponent: InventoryComponent) {
        guard let manager = manager else {
            return
        }

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

    private func updateGuestInventory(_ inventoryComponent: InventoryComponent) {
        guard let manager = manager else {
            return
        }

        for entityID in inventoryComponent.inventory.iterable {
            guard let entity = manager.entity(with: entityID)
            else { continue }

            // TODO: Hide PowerUp from scene
        }
    }
}
