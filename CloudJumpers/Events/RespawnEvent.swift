//
//  RespawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/30/22.
//

import Foundation
import CoreGraphics

class RespawnEvent: SharedEvent {
    var isSharing: Bool

    var isExecutedLocally: Bool
    var timestamp: TimeInterval
    var position: CGPoint

    var entityID: EntityID
    init(onEntityWith id: EntityID,
         to position: CGPoint,
         isSharing: Bool = false,
         isExecutedLocally: Bool = true) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.position = position
        self.isSharing = isSharing
        self.isExecutedLocally = isExecutedLocally
    }

    init(onEntityWith id: EntityID,
         at timestamp: TimeInterval,
         to position: CGPoint,
         isSharing: Bool = false,
         isExecutedLocally: Bool = true) {
        self.entityID = id
        self.timestamp = timestamp
        self.position = position
        self.isSharing = isSharing
        self.isExecutedLocally = isExecutedLocally
    }

    func execute(in entityManager: EntityManager) -> [Event]? {
        guard let entity = entityManager.entity(with: entityID),
              let spriteComponent = entityManager.component(ofType: SpriteComponent.self, of: entity)
        else { return nil }
        let effectEvent = RespawnEffectEvent(onEntityWith: entityID,
                                             at: spriteComponent.node.position)
        spriteComponent.node.position = position

        return [effectEvent]
    }

    func getSharedCommand() -> GameEventCommand {
        let onlineUpdate = OnlineRespawnEvent(positionX: position.x, positionY: position.y)
        return RespawnEventCommand(sourceId: entityID, event: onlineUpdate)
    }
}
