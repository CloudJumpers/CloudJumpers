//
//  PowerUpEffectStartEventCommand.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation
import CoreGraphics

struct PowerUpEffectStartEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalPowerUpStartEvent) {
        self.source = sourceId
        self.isSourceRecipient = false
        self.payload = CJNetworkEncoder.toJsonString(event)
    }

    init(_ source: NetworkID, _ payload: String) {
        self.source = source
        self.payload = payload
    }

    mutating func unpackIntoEventManager(_ eventManager: EventManager) -> Bool {
        let jsonData = Data(payload.utf8)
        let decoder = JSONDecoder()

        guard let parameters = try? decoder.decode(ExternalPowerUpStartEvent.self, from: jsonData),
              let powerUpType = PowerUpComponent.Kind(rawValue: parameters.activatePowerUpType) else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let eventToProcess = PowerUpEffectStartEvent(position: CGPoint(x: parameters.activatePowerUpPositionX,
                                                                       y: parameters.activatePowerUpPositionY),
                                                     at: parameters.timestamp,
                                                     powerUpType: powerUpType)
        eventManager.add(eventToProcess)
        return true
    }
}
