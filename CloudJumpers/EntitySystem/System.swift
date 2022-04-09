//
//  System.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 23/3/22.
//

import CoreGraphics

protocol System: AnyObject {
    var active: Bool { get set }

    init(for manager: EntityManager)
    func shouldUpdate(within time: CGFloat, in entityManager: EntityManager) -> Bool
    func update(within time: CGFloat, in entityManager: EntityManager)
}

extension System {
    func shouldUpdate(within time: CGFloat, in entityManager: EntityManager) -> Bool { true }
}
