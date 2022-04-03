//
//  LogEvent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 31/3/22.
//

import Foundation

struct LogEvent: Event {
    let timestamp: TimeInterval
    let entityID: EntityID

    private let message: String

    init(_ message: String) {
        timestamp = EventManager.timestamp
        entityID = ""
        self.message = message
    }

    func execute(in entityManager: EntityManager, thenSuppliesInto supplier: inout Supplier) {
        print(message)
    }
}
