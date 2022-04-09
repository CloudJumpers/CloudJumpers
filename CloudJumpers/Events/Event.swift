//
//  Event.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import Foundation

protocol Event {
    var timestamp: TimeInterval { get }
    var entityID: EntityID { get }

    func shouldExecute(in target: EventModifiable) -> Bool
    func execute(in target: EventModifiable, thenSuppliesInto supplier: inout Supplier)
}

extension Event {
    func shouldExecute(in target: EventModifiable) -> Bool { true }

    func then(do event: Event) -> Event {
        BiEvent(self, event)
    }
}
