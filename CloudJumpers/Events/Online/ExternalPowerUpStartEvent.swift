//
//  ExternalPowerUpStartEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation

struct ExternalPowerUpStartEvent: RemoteEvent {
    var activatePowerUpPositionX: Double
    var activatePowerUpPositionY: Double
    var activatePowerUpId: EntityID
    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return PowerUpEffectStartEventCommand(sourceId: sourceId, event: self)
    }
}
