//
//  ContactComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import SpriteKit

class ContactComponent: Component {
    let entityA: Entity
    let entityB: Entity
    let contactType: ContactType

    init (entityA: Entity, entityB: Entity, type: ContactType) {
        self.entityA = entityA
        self.entityB = entityB
        self.contactType = type
    }

    enum ContactType {
        case begin, end
    }
}
