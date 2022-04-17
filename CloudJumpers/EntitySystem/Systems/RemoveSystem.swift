//
//  RemoveSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

class RemoveSystem: System {
    var active = true

    private var boundSize: CGSize?
    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    convenience init(for manager: EntityManager, boundSize: CGSize, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.init(for: manager, dispatchesVia: dispatcher)
        self.boundSize = boundSize
    }

    // TODO: Should system be able to remove entities ?
    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for entity in manager.entities {
            updateRemoveWithTime(entity: entity)
            updateRemoveOutOfBound(entity: entity)
        }
    }

    func updateRemoveWithTime(entity: Entity) {

        // TODO: Probably no need two separate components for this
        guard let manager = manager,
              let timedComponent = manager.component(ofType: TimedComponent.self, of: entity),
              let timedRemoveComponent = manager.component(ofType: TimedRemovalComponent.self, of: entity),
              timedComponent.time >= timedRemoveComponent.timeToRemove
        else { return }
        
        cleanUpBeforeRemove(entity: entity)
        manager.remove(entity)

    }

    func updateRemoveOutOfBound (entity: Entity) {
        guard let manager = manager else {
            return
        }

        for positionComponent in manager.components(ofType: PositionComponent.self)
        where isOutOfBound(position: positionComponent.position) {
            if let entity = positionComponent.entity {
                manager.remove(entity)
            }
        }
    }
    
    func cleanUpBeforeRemove(entity: Entity) {
        guard let manager = manager,
              manager.component(ofType: BlackoutComponent.self, of: entity) != nil,
              let areaComponent = manager.components(ofType: AreaComponent.self).first else {
            return
        }
        
        areaComponent.isBlank = false
    }

    private func isOutOfBound(position: CGPoint) -> Bool {
        guard let boundSize = boundSize else {
            return false
        }

        let minX = -boundSize.width / 2 - Constants.outOfBoundBufferX
        let maxX = boundSize.width / 2 + Constants.outOfBoundBufferX
        let minY = Constants.minOutOfBoundBufferY
        let maxY = boundSize.height + Constants.outOfBoundBufferY

        return position.x < minX || position.x > maxX ||
        position.y < minY || position.y > maxY
    }

}
