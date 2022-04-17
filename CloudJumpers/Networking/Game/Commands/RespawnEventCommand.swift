//
//  RespawnEffectEventCommand.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/2/22.
//

import Foundation
import CoreGraphics

struct RespawnEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalRespawnEvent) {
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

        guard let parameters = try? decoder.decode(ExternalRespawnEvent.self, from: jsonData) else {
            nextCommand = DisasterStartEventCommand(source, payload)
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let position = CGPoint(x: parameters.positionX, y: parameters.positionY)
        let eventToProcess = RespawnEvent(
            onEntityWith: source,
            killedBy: parameters.killedBy,
            newPosition: position,
            at: parameters.timestamp
        )

        eventManager.add(eventToProcess)
        return true
    }
}
