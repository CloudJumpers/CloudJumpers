//
//  KilledEntityEventCommand.swift
//  CloudJumpers
//
//  Created by Eric Bryan on 18/4/22.
//

import Foundation
import CoreGraphics

struct KilledEntityEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalKillEntityEvent) {
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

        guard let parameters = try? decoder.decode(ExternalKillEntityEvent.self, from: jsonData)
        else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let eventToProcess = KillEvent(byEntityWith: source, targetID: parameters.killedEntityID,
                                       newPosition: Constants.playerInitialPosition)
        eventManager.add(eventToProcess)
        return true
    }
}
