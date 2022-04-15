//
//  ExternalPowerUpSpawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation
import CoreGraphics

struct ExternalPowerUpSpawnEvent: RemoteEvent {
    var powerSpawnPositionX: Double
    var powerSpawnPositionY: Double
    var powerUpType: String
    var powerUpId: String

    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return PowerUpSpawnEventCommand(sourceId: sourceId, event: self)
    }
}
