//
//  Entities.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import Foundation
import CoreGraphics

protocol Entity: AnyObject {
    typealias ID = UUID

    var id: ID { get }

    func setUpAndAdd(to manager: EntityManager)
}
