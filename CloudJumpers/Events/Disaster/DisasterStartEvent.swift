//
//  DisasterStartEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation
import CoreGraphics

struct DisasterStartEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var position: CGPoint
    private var velocity: CGVector
    private var disasterType: DisasterComponent.Kind

    init(position: CGPoint,
         velocity: CGVector,
         disasterType: DisasterComponent.Kind,
         entityId: EntityID) {
        timestamp = EventManager.timestamp
        entityID = entityId
        self.position = position
        self.velocity = velocity
        self.disasterType = disasterType
     }

    init(position: CGPoint,
         at timestamp: TimeInterval,
         velocity: CGVector,
         disasterType: DisasterComponent.Kind,
         entityId: EntityID
    ) {
        entityID = entityId
        self.position = position
        self.timestamp = timestamp
        self.velocity = velocity
        self.disasterType = disasterType
     }

    func execute(in entityManager: EntityManager) -> (localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        let disasterPromptId = EntityManager.newEntityID
        let disasterSpawnEvent = DisasterSpawnEvent(
            position: position,
            velocity: velocity,
            disasterType: disasterType,
            entityId: entityID,
            promptId: disasterPromptId)

        return ( [DisasterPromptEffectEvent(onEntityWith: disasterPromptId, at: position, for: disasterType),
                  disasterSpawnEvent], nil)
    }
}
