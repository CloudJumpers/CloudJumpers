//
//  LocationSystem.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/11/22.
//

import Foundation
import CoreGraphics

class StandOnSystem: System {
    var active = true

    unowned var manager: EntityManager?
    unowned var dispatcher: EventDispatcher?

    required init(for manager: EntityManager, dispatchesVia dispatcher: EventDispatcher? = nil) {
        self.manager = manager
        self.dispatcher = dispatcher
    }

    func changeStandOnEntity(for id: EntityID, to standOnEntityID: EntityID?, at timestamp: TimeInterval) {
        guard let standOnComponent = manager?.component(ofType: StandOnComponent.self, of: id) else {
            return
        }

        if checkPositionOnTopPlatform(for: id, to: standOnEntityID) || standOnEntityID == nil {
            standOnComponent.standOnEntityID = standOnEntityID
            standOnComponent.timestamp = timestamp
        }
    }

    func checkPositionOnTopPlatform(for id: EntityID, to standOnEntityID: EntityID?) -> Bool {
        guard let standOnEntityID = standOnEntityID,
              let platformPosition = manager?.component(ofType: PositionComponent.self, of: standOnEntityID)?.position,
              let platformSize = manager?.component(ofType: SpriteComponent.self, of: standOnEntityID)?.size,
              let playerPosition = manager?.component(ofType: PositionComponent.self, of: id)?.position,
              let playerSize = manager?.component(ofType: SpriteComponent.self, of: id)?.size
        else {
            return false
        }
        let platformTopLeftX = platformPosition.x - platformSize.width / 2
        let platformTopRightX = platformPosition.x + platformSize.width / 2
        let platformY = platformPosition.y

        return playerPosition.x > platformTopLeftX - playerSize.width / 2 &&
        playerPosition.x < platformTopRightX + playerSize.width / 2 &&
        playerPosition.y > platformY
    }
}
