//
//  RemoveSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/9/22.
//

import Foundation
import CoreGraphics

class RemoveSystem :System {
    var active: Bool = true
    
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    // TODO: Should system be able to remove entities ?
    func update(within time: CGFloat) {
        guard let manager = manager else {
            return
        }

        for entity in manager.getEntities() {
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
        else { return  }
        
        manager.remove(entity)

    }
    func updateRemoveOutOfBound (entity: Entity) {
        guard let manager = manager,
              manager.hasComponent(ofType: RemoveOutOfBoundTag.self, in: entity),
              let positionComponent = manager.component(ofType: PositionComponent.self, of: entity),
              isPositionOutOfBound(positionComponent.position)
        else { return  }

        manager.remove(entity)
    }
    
    private func isPositionOutOfBound(_ position: CGPoint) -> Bool {
        position.x < Constants.minOutOfBoundX || position.x > Constants.maxOutOfBoundX
    }
    
    
}
