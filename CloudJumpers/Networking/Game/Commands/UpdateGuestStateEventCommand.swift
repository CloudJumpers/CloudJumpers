//
//  RepositionEventCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 27/3/22.
//

import Foundation
import CoreGraphics

struct UpdateGuestStateEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: ExternalUpdateGuestStateEvent) {
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

        guard let parameters = try? decoder.decode(ExternalUpdateGuestStateEvent.self, from: jsonData) else {
            nextCommand = RespawnEventCommand(source, payload)
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let position = CGPoint(x: parameters.positionX, y: parameters.positionY)
        let eventToProcess = UpdateGuestStateEvent(
            onEntityWith: source,
            position: position,
            animationWith: parameters.animationKey,
            at: parameters.timestamp)

        eventManager.add(eventToProcess)
        return true
    }
}
