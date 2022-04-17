//
//  Area.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 17/4/22.
//

import CoreGraphics

class Area: Entity {
    let id: EntityID

    private let size: CGSize

    init(size: CGSize, with id: EntityID = EntityManager.newEntityID) {
        self.id = id
        self.size = size
    }

    func setUpAndAdd(to manager: EntityManager) {
        manager.addComponent(AreaComponent(size: size), to: self)
    }
}
