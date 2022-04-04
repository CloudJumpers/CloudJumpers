//
//  DisasterPromptEffectEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/3/22.
//

import SpriteKit

struct DisasterPromptEffectEvent: Event {
    var timestamp: TimeInterval

    var entityID: EntityID
    private var position: CGPoint
    private var disasterType: DisasterComponent.Kind

    init(onEntityWith id: EntityID, at position: CGPoint, for type: DisasterComponent.Kind) {
        timestamp = EventManager.timestamp
        self.entityID = id
        self.position = position
        self.disasterType = type

    }

    init(onEntityWith id: EntityID,
         at timestamp: TimeInterval,
         at position: CGPoint,
         for type: DisasterComponent.Kind) {
        self.entityID = id
        self.timestamp = timestamp
        self.position = position
        self.disasterType = type
    }

    func execute(in entityManager: EntityManager) ->(localEvents: [Event]?, remoteEvents: [RemoteEvent]?)? {
        let disasterPrompt = DisasterPrompt(disasterType, at: position, with: entityID)
        entityManager.add(disasterPrompt)

        return ([BlinkEffectEvent(on: disasterPrompt.id,
                                  duration: Constants.disasterPromptPeriod / 16,
                                  numberOfLoop: 8),
                 RemoveEntityEvent(disasterPrompt.id, after: Constants.disasterPromptPeriod)], nil)
    }
}
