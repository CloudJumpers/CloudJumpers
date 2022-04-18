//
//  GodPowerUpSpawnEventCommand.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/18/22.
//

import Foundation
import CoreGraphics

struct GodPowerUpSpawnEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalGodPowerUpSpawnEvent) {
        self.source = sourceId
        self.isSourceRecipient = true
        self.payload = CJNetworkEncoder.toJsonString(event)
    }

    init(_ source: NetworkID, _ payload: String) {
        self.source = source
        self.payload = payload
    }

    mutating func unpackIntoEventManager(_ eventManager: EventManager) -> Bool {
        let jsonData = Data(payload.utf8)
        let decoder = JSONDecoder()

        guard let parameters = try? decoder.decode(ExternalGodPowerUpSpawnEvent.self, from: jsonData),
              let type = PowerUpComponent.Kind(rawValue: parameters.godPowerUpType)
        else {
            nextCommand = KilledEntityEventCommand(source, payload)
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }
        let position = CGPoint(
            x: parameters.godPowerSpawnPositionX,
            y: parameters.godPowerSpawnPositionY)

        let eventToProcess = GodPowerUpSpawnEvent(
            entityID: source,
            position: position,
            type: type,
            powerUpID: parameters.godPowerUpId,
            at: parameters.timestamp)
        eventManager.add(eventToProcess)
        return true
    }
}
