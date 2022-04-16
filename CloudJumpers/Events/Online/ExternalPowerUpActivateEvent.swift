//
//  ExternalPowerUpStartEvent.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation

struct ExternalPowerUpActivateEvent: RemoteEvent {
    var activatePowerUpPositionX: Double
    var activatePowerUpPositionY: Double
    func createDispatchCommand() -> GameEventCommand? {
        guard let sourceId = getSourceId() else {
            return nil
        }

        return PowerUpEffectStartEventCommand(sourceId: sourceId, event: self)
    }
}
