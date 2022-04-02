//
//  RemoteEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 26/3/22.
//

import Foundation

/// A remote event is to be sent over the network to other devices,
/// which then leads to the creation of a corresponding event on those
/// devices, with the provided parameters.
protocol RemoteEvent: Codable {
    var timestamp: Double { get }

    /// createDispatchCommand generates a command corresponding
    /// to the calling remoteEvent instance, and populates it with
    /// parameters from the instance for delivery over the network.
    func createDispatchCommand() -> GameEventCommand?
}

extension RemoteEvent {
    var timestamp: Double { EventManager.timestamp }

    func getSourceId() -> NetworkID? {
        AuthService().getUserId()
    }
}
