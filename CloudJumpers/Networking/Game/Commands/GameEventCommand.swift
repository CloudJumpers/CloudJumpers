//
//  GameUpdateCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

protocol GameEventCommand {
    /// source refers to the identifier for the
    /// player this update originates from. By convention,
    /// we use the player's userId.
    var source: EntityID { get }

    /// recipients is a list of recipient userIds that should
    /// be concerned with this command, in the event of
    /// unicast or multicasting. If used in a broadcasting
    /// context, this can be left blank.
    var recipients: [EntityID]? { get }

    /// To have separation of concerns, we transport
    /// the payload as a String. It is to be handled based
    /// on the command type by the receiver.
    var payload: String { get }

    /// This uses the chain-of-responsibility pattern. If this
    /// Command type cannot process the given event, we
    /// pass the payload to the next one.
    var nextCommand: GameEventCommand? { get }

    /// processContents facilitates the unpacking
    /// and processing of contents, on the receiver-side.
    mutating func unpackIntoEvent(_ eventManager: EventManager) -> Bool
}
