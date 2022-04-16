//
//  OutOfBoundRemovalSystem.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 17/4/22.
//

import Foundation
import CoreGraphics

class OutOfBoundRemovalSystem: System {
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

    func update(within time: CGFloat) {
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
