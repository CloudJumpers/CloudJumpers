//
//  DisasterStartEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 2/4/22.
//

import Foundation
import CoreGraphics

struct DisasterActivateEvent: Event {
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

    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier) {
        let disaster = Disaster(
            disasterType,
            at: position,
            velocity: velocity,
            with: entityID)
        let disasterPrompt = DisasterPrompt(
            disasterType,
            at: position,
            with: entityID,
            intervalToRemove: Constants.disasterPromptPeriod)
        target.add(disaster)
        target.add(disasterPrompt)
    }
}
