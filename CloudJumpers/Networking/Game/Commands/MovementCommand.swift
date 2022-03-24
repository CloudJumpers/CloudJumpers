//
//  MovementCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

struct MovementCommand: GameEventCommand {
    var source: EntityID
    let recipients: [EntityID]?

    var payload: String

    var nextCommand: GameEventCommand?

    init(sourceId: EntityID, movementEvent: MovementEvent) {
        self.source = sourceId
        self.recipients = nil
        self.payload = CJNetworkEncoder.toJsonString(movementEvent)

        print("MovementCMD1: \(payload) \(source) \(recipients)")
    }

    init(sourceId: EntityID, recipients: [EntityID]?, payload: String) {
        self.source = sourceId
        self.recipients = recipients
        self.payload = payload
    }

    mutating func processEvent(_ eventManager: EventManager) -> Bool {
        let jsonData = Data(payload.utf8)
        let decoder = JSONDecoder()

        guard let _ = try? decoder.decode(MovementEvent.self, from: jsonData) else {
            return nextCommand?.processEvent(eventManager) ?? false
        }

        print("MovementCMD2: \(payload) \(source) \(recipients)")
        // At this point, add to event queue
        // eventManager.event ....

        return true
    }
}
