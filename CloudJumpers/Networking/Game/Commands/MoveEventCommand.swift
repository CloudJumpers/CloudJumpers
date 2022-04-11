//
//  MoveEventCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation
import CoreGraphics

struct MoveEventCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    /// This constructor is used for creation of a MoveEventCommand
    /// for distribution.
    init(sourceId: NetworkID, event: ExternalMoveEvent) {
        self.source = sourceId
        self.isSourceRecipient = false
        self.payload = CJNetworkEncoder.toJsonString(event)
    }

    init(_ sourceId: NetworkID, _ payload: String) {
        self.source = sourceId
        self.payload = payload
    }

    mutating func unpackIntoEventManager(_ eventManager: EventManager) -> Bool {
        let jsonData = Data(payload.utf8)
        let decoder = JSONDecoder()

        guard let parameters = try? decoder.decode(ExternalMoveEvent.self, from: jsonData) else {
            nextCommand = RepositionEventCommand(source, payload)
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let displacement = CGVector(dx: parameters.displacementX, dy: parameters.displacementY)
        let event = MoveEvent(onEntityWith: source, by: displacement, at: parameters.timestamp)
        eventManager.add(event)

        return true
    }
}
