//
//  DisasterSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics
import ContentGenerator

class DisasterSpawnSystem: System {
    var active = false

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    private var positionsTemplate: PositionsTemplate? {
        guard let size = manager?.components(ofType: AreaComponent.self).first?.size else {
            return nil
        }
        return PositionsTemplate(worldSize: size)
    }

    static let velocitiesTemplate = VelocitiesTemplate(
        xRange: Constants.Disasters.disasterMinXDirection...Constants.Disasters.disasterMaxXDirection,
        yRange: Constants.Disasters.disasterMinYDirection...Constants.Disasters.disasterMaxYDirection,
        within: Constants.Disasters.disasterMinSpeed...Constants.Disasters.disasterMaxSpeed)

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard RandomSpawnGenerator.isSpawning(successRate: 0.5),
              let positionsTemplate = positionsTemplate
        else { return }

        let velocity = RandomSpawnGenerator.getRandomVelocity(DisasterSpawnSystem.velocitiesTemplate)
        let position = RandomSpawnGenerator.getRandomPosition(positionsTemplate)
        let disasterType = DisasterComponent.Kind.randomly ?? .meteor

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
    }

    func spawn(_ type: DisasterComponent.Kind, at position: CGPoint, velocity: CGVector, with entityID: EntityID) {
        let disasterPrompt = DisasterPrompt(
            type,
            at: position,
            velocity: velocity,
            disasterTexture: .meteor,
            transformAfter: Constants.Disasters.disasterPromptPeriod,
            with: entityID)

        manager?.add(disasterPrompt)
    }
}
