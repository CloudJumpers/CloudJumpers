//
//  OnlineEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 26/3/22.
//

import Foundation

/// An online event is to be sent over the network to other devices,
/// which then leads to the creation of a corresponding event on those
/// devices, with the provided parameters.
protocol OnlineEvent: Codable {
    var timestamp: Double { get }
}

extension OnlineEvent {
    var timestamp: Double { EventManager.timestamp }
}
