//
//  System.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import CoreGraphics

protocol System: AnyObject {
    var manager: EntityManager? { get set }

    init(for manager: EntityManager)
    func update(within time: CGFloat)
}
