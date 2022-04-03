//
//  ObtainEntityCommand.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 3/4/22.
//

import Foundation
import CoreGraphics

struct ObtainEntityCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalObtainEntityEvent) {
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

        guard let parameters = try? decoder.decode(ExternalObtainEntityEvent.self, from: jsonData) else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let eventToProcess = ObtainEvent(on: source, obtains: parameters.obtainedEntityID)

        eventManager.add(eventToProcess)
        return true
    }
}
