//
//  MoveEventCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation
import CoreGraphics

struct MoveEventCommand: GameEventCommand {
    var source: NetworkID
    let recipients: [NetworkID]?

    var payload: String

    var nextCommand: GameEventCommand?

    /// This constructor is used for creation of a MoveEventCommand
    /// for distribution.
    init(sourceId: NetworkID, event: OnlineMoveEvent) {
        self.source = sourceId
        self.recipients = nil
        self.payload = CJNetworkEncoder.toJsonString(event)
    }

    init(_ sourceId: NetworkID, _ recipients: [NetworkID]?, _ payload: String) {
        self.source = sourceId
        self.recipients = recipients
        self.payload = payload
    }

    mutating func unpackIntoEventManager(_ eventManager: EventManager) -> Bool {
        let jsonData = Data(payload.utf8)
        let decoder = JSONDecoder()

        guard let parameters = try? decoder.decode(OnlineMoveEvent.self, from: jsonData) else {
            return nextCommand?.unpackIntoEventManager(eventManager) ?? false
        }

        let displacement = CGVector(dx: parameters.displacementX, dy: parameters.displacementY)
        let event = MoveEvent(onEntityWith: source, at: parameters.timestamp, by: displacement)
        eventManager.add(event)

        return true
    }
}
