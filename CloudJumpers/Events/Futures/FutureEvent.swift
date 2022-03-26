//
//  FutureEvent.swift
//  CloudJumpers
//
//  Created by Sujay R Subramanian on 26/3/22.
//

import Foundation

/// FutureEvent leads to the creation of a corresponding event
/// with the provided parameters, upon being received by a device.
protocol FutureEvent: Codable {
    var timestamp: Double { get }
}

extension FutureEvent {
    var timestamp: Double { EventManager.timestamp }
}
