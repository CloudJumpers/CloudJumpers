//
//  DisasterSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics


class DisasterSpawnSystem : System {
    var active: Bool = true
    
    unowned var manager: EntityManager?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    
    func update(within time: CGFloat) {
        let eventInfo = DisasterGenerator.createRandomDisaster(within: metaData.highestPosition.y) 
        let disasterId = EntityManager.newEntityID
        let localDisasterStart = DisasterStartEvent(
             position: eventInfo.position,
             velocity: eventInfo.velocity,
             disasterType: eventInfo.type,
             entityId: disasterId)
        let remoteDisasterStart = ExternalDisasterEvent(
             disasterPositionX: eventInfo.position.x,
             disasterPositionY: eventInfo.position.y,
             disasterVelocityX: eventInfo.velocity.dx,
             disasterVelocityY: eventInfo.velocity.dy,
             disasterType: eventInfo.type.rawValue,
             disasterId: disasterId)
    }
}
