//
//  Effector.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 3/4/22.
//

protocol Effector {
    var entityID: EntityID { get }

    func apply(to event: Event) -> Event
    func shouldDetach(in target: EventModifiable) -> Bool
}

extension Effector {
    func shouldDetach(in target: EventModifiable) -> Bool { true }
}
