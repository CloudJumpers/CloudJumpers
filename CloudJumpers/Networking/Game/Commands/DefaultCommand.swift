//
//  DefaultCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

class DefaultCommand: GameEventCommand {
    let source: EntityID
    var recipients: [EntityID]?
    var payload: String

    var nextCommand: GameEventCommand?

    init(sourceId: EntityID, recipients: [EntityID]?, payload: String) {
        self.source = sourceId
        self.recipients = recipients
        self.payload = payload
    }

    func processEvent(_ eventManager: EventManager) -> Bool {
        nextCommand = MovementCommand(sourceId: source, recipients: recipients, payload: payload)
        return nextCommand?.processEvent(eventManager) ?? false
    }
}
