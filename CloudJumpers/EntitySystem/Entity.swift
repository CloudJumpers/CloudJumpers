//
//  Entities.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

protocol Entity: AnyObject {
    var id: EntityID { get }

    func setUpAndAdd(to manager: EntityManager)
}
