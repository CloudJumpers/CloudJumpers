//
//  DisasterSpawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/3/22.
//

import SpriteKit

struct DisasterSpawnEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private var position: CGPoint
    private var velocity: CGVector
    private var disasterType: DisasterComponent.Kind
    private var promptId: EntityID

    init(position: CGPoint,
         velocity: CGVector,
         disasterType: DisasterComponent.Kind,
         entityId: EntityID,
         promptId: EntityID
    ) {
        timestamp = EventManager.timestamp
        entityID = entityId
        self.position = position
        self.velocity = velocity
        self.disasterType = disasterType
        self.promptId = promptId
     }

    func shouldExecute(in entityManager: EntityManager) -> Bool {
        entityManager.entity(with: promptId) == nil
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        let disaster = Disaster(disasterType, at: position, velocity: velocity, with: entityID)
        entityManager.add(disaster)
        supplier.add(RemoveUnboundEntityEvent(disaster))
    }
}
