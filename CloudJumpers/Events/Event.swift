//
//  Event.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import Foundation

protocol Event: Codable {
    var timestamp: TimeInterval { get }
    var entityID: EntityID { get }

    func execute(in entityManager: EntityManager)
}

extension Event {
    func execute(in entityManager: EntityManager) { }
}
