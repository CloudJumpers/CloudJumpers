//
//  Entities.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation

typealias EntityID = String

protocol Entity: AnyObject {
    var id: EntityID { get }

    func setUpAndAdd(to manager: EntityManager)
}

extension Entity {
    static var newID: EntityID {
        UUID().uuidString
    }
}
