//
//  Component.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

typealias ComponentID = String

protocol Component: AnyObject {
    var id: ComponentID { get }
    var entity: Entity? { get set }
}
