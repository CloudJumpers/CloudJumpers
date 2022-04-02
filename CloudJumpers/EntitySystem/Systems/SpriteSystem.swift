//
//  SpriteSystem.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import SpriteKit

class SpriteSystem: System {
    unowned var manager: EntityManager?
    unowned var delegate: SpriteSystemDelegate?

    private var sprites: [EntityID: SKNode]
    var metaData: GameMetaData?

    required init(for manager: EntityManager) {
        sprites = [:]
        self.manager = manager
    }

    convenience init(for manager: EntityManager, rendersTo delegate: SpriteSystemDelegate) {
        self.init(for: manager)
        self.delegate = delegate
    }

    // MARK: - System Update
    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        var entitiesToPrune = Set(sprites.keys)

        for spriteComponent in manager.components(ofType: SpriteComponent.self) {
            guard let entity = spriteComponent.entity else {
                fatalError("SpriteComponent does not contain reference to its Entity")
            }

            markInvalidEntity(entity, into: &entitiesToPrune)
            updateNode(spriteComponent.node, with: entity)
        }

        pruneSprites(in: entitiesToPrune)

        if let playerId = metaData?.playerId {
            updateInventory(of: playerId)
        }
    }

    private func updateNode(_ node: SKNode, with entity: Entity) {
        synchronizeSprite(node, with: entity)
        updateAnimation(of: node, with: entity)
        updateTimed(of: node, with: entity)
    }

    // MARK: - Per-component Updates
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
            node.removeAllActions()
            node.run(.repeatForever(.animate(
                with: texture,
                timePerFrame: 0.1,
                resize: false,
                restore: true)),
            withKey: animationComponent.kind.name)
        }
    }

    private func updateInventory(of entityID: EntityID) {
        guard let entity = manager?.entity(with: entityID),
              let inventoryComponent = manager?.component(ofType: InventoryComponent.self, of: entity),
              inventoryComponent.inventory.isUpdated else {
            return
        }

        inventoryComponent.inventory.isUpdated = false
        var position = Constants.initialPowerUpQueuePosition
        var displayCount = 0

        for entityID in inventoryComponent.inventory.iterable {
            guard let entity = manager?.entity(with: entityID),
                  let spriteComponent = manager?.component(ofType: SpriteComponent.self, of: entity),
                  let ownerComponent = manager?.component(ofType: OwnerComponent.self, of: entity),
                  ownerComponent.ownerEntityId != nil
            else { continue }

            guard displayCount <= Constants.powerUpMaxNumDisplay else {
                break
            }

            displayCount += 1

            spriteComponent.node.position = position
            spriteComponent.node.physicsBody = nil

            position.x += Constants.powerUpQueueXInterval
        }
    }

    // MARK: - Rendering Lifecycle
    private func synchronizeSprite(_ node: SKNode, with entity: Entity) {
        if isEntityNotRendered(entity, node) ||
           isEntityInSpriteSystemNotInParent(entity, node) {
            addSprite(node, with: entity)
        } else if isEntityInParentNotInSpriteSystem(entity, node) {
            removeSprite(node, with: entity.id)
        }
    }

    private func addSprite(_ node: SKNode, with entity: Entity) {
        let `static` = manager?.hasComponent(ofType: CameraStaticTag.self, in: entity)
        delegate?.spriteSystem(self, addNode: node, static: `static` ?? false)
        bindCameraToSprite(node, with: entity)

        sprites[entity.id] = node
    }

    private func removeSprite(_ node: SKNode, with entityID: EntityID) {
        delegate?.spriteSystem(self, removeNode: node)

        sprites[entityID] = nil
    }

    private func markInvalidEntity(_ entity: Entity, into entitiesToPrune: inout Set<EntityID>) {
        if entitiesToPrune.contains(entity.id) {
            entitiesToPrune.remove(entity.id)
        }
    }

    private func pruneSprites(in entitiesToPrune: Set<EntityID>) {
        for entityID in entitiesToPrune {
            guard let node = sprites[entityID] else {
                continue
            }

            removeSprite(node, with: entityID)
        }
    }

    private func isEntityNotRendered(_ entity: Entity, _ node: SKNode) -> Bool {
        !sprites.contains(key: entity.id) && node.parent == nil
    }

    private func isEntityInSpriteSystemNotInParent(_ entity: Entity, _ node: SKNode) -> Bool {
        sprites.contains(key: entity.id) && node.parent == nil
    }

    private func isEntityInParentNotInSpriteSystem(_ entity: Entity, _ node: SKNode) -> Bool {
        node.parent != nil && !sprites.contains(key: entity.id)
    }

    private func bindCameraToSprite(_ node: SKNode, with entity: Entity) {
        guard manager?.hasComponent(ofType: CameraAnchorTag.self, in: entity) ?? false else {
            return
        }

        delegate?.spriteSystem(self, bindCameraTo: node)
    }
}
