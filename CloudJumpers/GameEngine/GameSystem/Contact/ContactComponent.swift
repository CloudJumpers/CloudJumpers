//
//  ContactComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import SpriteKit

class ContactComponent: Component {
    let entity: Entity
    let contactType: ContactType

    init (entity: Entity, type: ContactType) {
        self.entity = entity
        self.contactType = type
    }

    enum ContactType {
        case begin, end
    }
}
