//
//  ExternalGodPowerUpSpawnEvent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/18/22.
//

import Foundation

struct ExternalGodPowerUpSpawnEvent: RemoteEvent {
    var godPowerSpawnPositionX: Double
    var godPowerSpawnPositionY: Double
    var godPowerUpType: String
    var godPowerUpId: String

    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }
        return GodPowerUpSpawnEventCommand(sourceId: sourceId, event: self)
    }
}
