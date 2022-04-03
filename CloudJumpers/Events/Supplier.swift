//
//  Supplier.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

struct Supplier {
    var events: [Event]
    var remoteEvents: [RemoteEvent]
    var effectors: [Effector]

    init() {
        events = []
        remoteEvents = []
        effectors = []
    }

    mutating func add(_ event: Event) {
        events.append(event)
    }

    mutating func add(_ remoteEvent: RemoteEvent) {
        remoteEvents.append(remoteEvent)
    }

    mutating func add(_ effector: Effector) {
        effectors.append(effector)
    }
}
