//
//  GameUpdateCommand.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 24/3/22.
//

import Foundation

protocol GameEventCommand {
    /// source refers to the identifier for the
    /// device this update originates from. By convention,
    /// we use the player's userId, which also serves as the
    /// device's network id.
    var source: NetworkID { get }

    /// recipients is a list of recipient ids that should
    /// be concerned with this command, in the event of
    /// unicast or multicasting. If used in a broadcasting
    /// context, this can be left as nil.
    var recipients: [NetworkID]? { get }

    /// The payload is transported as a String.
    /// It is to be handled based on the command
    /// type by the receiver.
    var payload: String { get }

    /// This uses the chain-of-responsibility pattern. If this
    /// Command type cannot process the given event, we
    /// pass the payload to the next one.
    var nextCommand: GameEventCommand? { get }

    /// Facilitates the unpacking and processing of contents.
    mutating func unpackIntoEventManager(_ eventManager: EventManager) -> Bool

    /// This constructor is used for recovery of a GameEventCommand
    /// received from another device.
    init(_ source: NetworkID, _ recipients: [NetworkID]?, _ payload: String)
}
