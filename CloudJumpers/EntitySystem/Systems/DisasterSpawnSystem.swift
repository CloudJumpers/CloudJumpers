//
//  DisasterSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class DisasterSpawnSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    var blueprint: Blueprint?

    required init(for manager: EntityManager) {
        self.manager = manager
    }

    convenience init(for manager: EntityManager, blueprint: Blueprint) {
        self.init(for: manager)
        self.blueprint = blueprint
    }

    func update(within time: CGFloat) {
        guard RandomSpawnGenerator.isSpawning(successRate: 0.5),
              let blueprint = blueprint
        else {
            return
        }

        let velocity = RandomSpawnGenerator.getRandomVector(blueprint: blueprint)
        let position = RandomSpawnGenerator.getRandomPosition(blueprint: blueprint)
        let disasterType: DisasterComponent.Kind = RandomSpawnGenerator.getRandomDisasterType() ?? .meteor

        // TODO: Change this
        let disasterId = EntityManager.newEntityID
        let localDisasterStart = DisasterSpawnEvent(
             position: position,
             velocity: velocity,
             disasterType: disasterType,
             entityId: disasterId)
        let remoteDisasterStart = ExternalDisasterEvent(
             disasterPositionX: position.x,
             disasterPositionY: position.y,
             disasterVelocityX: velocity.dx,
             disasterVelocityY: velocity.dy,
             disasterType: disasterType.rawValue,
             disasterId: disasterId)
        manager?.add(localDisasterStart)
        dispatcher?.dispatch(remoteDisasterStart)

        // TODO: Dispatch only
    }
}
