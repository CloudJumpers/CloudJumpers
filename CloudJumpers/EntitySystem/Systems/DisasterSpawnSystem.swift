//
//  DisasterSpawnSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/10/22.
//

import Foundation
import CoreGraphics

class DisasterSpawnSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    private var positionGenerationInfo: RandomPositionGenerationInfo? {
        guard let size = manager?.components(ofType: AreaComponent.self).first?.size else {
            return nil
        }
        return RandomPositionGenerationInfo(worldSize: size)
    }

    static let  velocityGenerationInfo = RandomVelocityGenerationInfo(
        xRange: Constants.disasterMinXDirection...Constants.disasterMaxXDirection,
        yRange: Constants.disasterMinYDirection...Constants.disasterMaxYDirection,
        speedRange: Constants.disasterMinSpeed...Constants.disasterMaxSpeed)

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func update(within time: CGFloat) {
        guard RandomSpawnGenerator.isSpawning(successRate: 0.5),
              let positionGenerationInfo = positionGenerationInfo
        else {
            return
        }

        let velocity = RandomSpawnGenerator.getRandomVelocity(DisasterSpawnSystem.velocityGenerationInfo)
        let position = RandomSpawnGenerator.getRandomPosition(positionGenerationInfo)
        let disasterType: DisasterComponent.Kind = RandomSpawnGenerator.getRandomDisasterType() ?? .meteor

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
        let disasterPrompt = DisasterPrompt(type, at: position, velocity: velocity,
                                            disasterTexture: .meteor, transformAfter: Constants.disasterPromptPeriod,
                                            with: entityID)

        manager?.add(disasterPrompt)
    }
}
