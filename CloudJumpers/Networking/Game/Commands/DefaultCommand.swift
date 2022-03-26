//
//  DefaultCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

class DefaultCommand: GameEventCommand {
    let source: NetworkID
    var recipients: [NetworkID]?
    var payload: String

    var nextCommand: GameEventCommand?

    required init(_ sourceId: NetworkID, _ recipients: [NetworkID]?, _ payload: String) {
        self.source = sourceId
        self.recipients = recipients
        self.payload = payload
    }

    func unpackIntoEventManager(_ eventManager: EventManager) -> Bool {
        nextCommand = PositionalUpdateCommand(source, recipients, payload)
        return nextCommand?.unpackIntoEventManager(eventManager) ?? false
    }
}
