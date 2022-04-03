//
//  RemoveEventCommand.swift
//  CloudJumpers
//
//  Created by Trong Tan on 4/3/22.
//

import Foundation

struct RemoveEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalRemoveEvent) {
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

        guard let parameters = try? decoder.decode(ExternalRemoveEvent.self, from: jsonData) else {
            nextCommand = PowerUpEffectStartEventCommand(source, payload)
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let eventToProcess = RemoveEntityEvent(parameters.entityToRemoveId)
        eventManager.add(eventToProcess)
        return true
    }
}
