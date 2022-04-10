//
//  System.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import CoreGraphics

protocol System: AnyObject {
    var active: Bool { get set }
    var manager: EntityManager? { get set }

    init(for manager: EntityManager)
    func shouldUpdate(within time: CGFloat) -> Bool
    func update(within time: CGFloat)
}

extension System {
    func shouldUpdate(within time: CGFloat) -> Bool { true }
}
