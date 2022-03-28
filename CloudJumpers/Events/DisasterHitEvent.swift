//
//  DisasterHitEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 28/3/22.
//

import Foundation

struct DisasterHitEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let otherEntityID: EntityID

    init(from entityID: EntityID, on otherEntityID: EntityID) {
        timestamp = EventManager.timestamp
        self.entityID = entityID
        self.otherEntityID = otherEntityID
    }

    func execute(in entityManager: EntityManager) {
        guard let disaster = entityManager.entity(with: entityID),
              let disasterSpriteComponent = entityManager.component(ofType: SpriteComponent.self, of: disaster)
        else { return }

        disasterSpriteComponent.setRemoveNodeFromScene(true)
        // handle something on the thing the disaster land on
    }
}
