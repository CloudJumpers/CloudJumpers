//
//  DefaultCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

class DefaultCommand: GameEventCommand {
    let source: NetworkID
    let payload: String
    private(set) var isSourceRecipient: Bool?
    private(set) var nextCommand: GameEventCommand?

    required init(_ sourceId: NetworkID, _ payload: String) {
        self.source = sourceId
        self.payload = payload
    }

    func unpackIntoEventManager(_ eventManager: EventManager) -> Bool {
        nextCommand = MoveEventCommand(source, payload)
        return nextCommand?.unpackIntoEventManager(eventManager) ?? false
    }
}
