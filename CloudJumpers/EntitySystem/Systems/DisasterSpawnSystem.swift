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

        let remoteDisasterStart = ExternalDisasterEvent(
             disasterPositionX: position.x,
             disasterPositionY: position.y,
             disasterVelocityX: velocity.dx,
             disasterVelocityY: velocity.dy,
             disasterType: disasterType.rawValue,
             disasterId: disasterId)

        dispatcher?.dispatch(remoteDisasterStart)

        spawn(disasterType, at: position, velocity: velocity, with: disasterId)

        // TODO: Dispatch only
    }

    func spawn(_ type: DisasterComponent.Kind, at position: CGPoint, velocity: CGVector, with entityID: EntityID) {
        let disaster = Disaster(type, at: position, velocity: velocity, texture: .meteor, with: entityID)
        let disasterPrompt = DisasterPrompt(type, at: position, removeAfter: Constants.disasterPromptPeriod)

        manager?.add(disaster)
        manager?.add(disasterPrompt)
    }
}
