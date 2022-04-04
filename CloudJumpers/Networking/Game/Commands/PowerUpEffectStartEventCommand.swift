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
            nextCommand = ObtainEntityCommand(source, payload)
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        var eventToProcess: Event
        switch powerUpType {
        case .freeze:
            eventToProcess = FreezeEvent(by: source,
                                         at: CGPoint(x: parameters.activatePowerUpPositionX,
                                                     y: parameters.activatePowerUpPositionY),
                                         timestamp: parameters.timestamp)
        case .confuse:
            eventToProcess = ConfuseEvent(by: source,
                                          at: CGPoint(x: parameters.activatePowerUpPositionX,
                                                      y: parameters.activatePowerUpPositionY),
                                          timestamp: parameters.timestamp)
        }

        eventManager.add(eventToProcess)
        return true
    }
}
