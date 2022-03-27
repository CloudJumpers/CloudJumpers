//
//  RepositionEventCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 27/3/22.
//

import Foundation
import CoreGraphics

struct RepositionEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, event: OnlineRepositionEvent) {
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

        guard
            let parameters = try? decoder.decode(OnlineRepositionEvent.self, from: jsonData),
            let movementKind = Textures.Kind(rawValue: parameters.texture)
        else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let eventToProcess = RepositionEvent(
            onEntityWith: source,
            at: parameters.timestamp,
            to: CGPoint(x: parameters.positionX, y: parameters.positionY),
            as: movementKind
        )

        eventManager.add(eventToProcess)
        return true
    }
}
