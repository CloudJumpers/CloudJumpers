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
         entityId: EntityID) {
        entityID = entityId
        self.position = position
        self.timestamp = timestamp
        self.velocity = velocity
        self.disasterType = disasterType
     }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        let disasterPrompt = DisasterPrompt(disasterType, at: position)
        entityManager.add(disasterPrompt)

        let disaster = Disaster(disasterType, at: position, velocity: velocity, with: entityID)

        supplier.add(BlinkEffectEvent(
            on: disasterPrompt.id,
            duration: Constants.disasterPromptPeriod / 20,
            numberOfLoop: 10))

        supplier.add(RemoveEntityEvent(disasterPrompt.id, after: Constants.disasterPromptPeriod))

        supplier.add(ConditionalEvent(
            disaster,
            until: { entityManager.entity(with: disasterPrompt.id) == nil },
            action: {
                entityManager.add(disaster)
                return [RemoveUnboundEntityEvent(disaster)]
            }))
    }
}
