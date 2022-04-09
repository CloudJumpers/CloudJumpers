//
//  Entities.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

typealias EntityID = String

protocol Entity: AnyObject, Collidable {
    var id: EntityID { get }

    func setUpAndAdd(to manager: EntityManager)
}
