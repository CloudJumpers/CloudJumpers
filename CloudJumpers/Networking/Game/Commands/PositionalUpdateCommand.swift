//
//  PositionalUpdateCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation
import CoreGraphics

struct PositionalUpdateCommand: GameEventCommand {
    var source: NetworkID
    let recipients: [NetworkID]?

    var payload: String

    var nextCommand: GameEventCommand?

    init(sourceId: NetworkID, futureMovementEvent: FutureMovementEvent) {
        self.source = sourceId
        self.recipients = nil
        self.payload = CJNetworkEncoder.toJsonString(futureMovementEvent)
    }

    init(sourceId: NetworkID, recipients: [NetworkID]?, payload: String) {
        self.source = sourceId
        self.recipients = recipients
        self.payload = payload
    }

    mutating func unpackIntoEvent(_ eventManager: EventManager) -> Bool {
        let jsonData = Data(payload.utf8)
        let decoder = JSONDecoder()

        guard let parameters = try? decoder.decode(FutureMovementEvent.self, from: jsonData) else {
            return nextCommand?.unpackIntoEvent(eventManager) ?? false
        }

        let displacement = CGVector(dx: parameters.positionX, dy: parameters.positionY)
        let event = MoveEvent(source, parameters.timestamp, by: displacement)
        eventManager.add(event)

        return true
    }
}
