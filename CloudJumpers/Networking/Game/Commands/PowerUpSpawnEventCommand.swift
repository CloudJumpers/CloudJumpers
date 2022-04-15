//
//  PowerUpSpawnEventCommand.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/15/22.
//

import Foundation
import CoreGraphics

struct PowerUpSpawnEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalPowerUpSpawnEvent) {
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

        guard let parameters = try? decoder.decode(ExternalPowerUpSpawnEvent.self, from: jsonData),
              let type = PowerUpComponent.Kind(rawValue: parameters.powerUpType)
        else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }
        let position = CGPoint(x: parameters.powerSpawnPositionX, y: parameters.powerSpawnPositionY)

        let eventToProcess = PowerUpSpawnEvent(
            position: position,
            type: type,
            entityId: parameters.powerUpId,
            at: parameters.timestamp)
        eventManager.add(eventToProcess)
        return true
    }
}
