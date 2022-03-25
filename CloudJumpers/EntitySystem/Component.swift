//
//  Component.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation

protocol Component: AnyObject {
    typealias ID = UUID

    var id: ID { get }
    var entity: Entity? { get set }
}
