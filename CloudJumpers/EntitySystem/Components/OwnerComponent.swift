//
//  OwnerComponent.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 31/3/22.
//

class OwnerComponent: Component {
    var ownerEntityId: EntityID?

    init(ownerEntityId: EntityID? = nil) {
        self.ownerEntityId = ownerEntityId
        super.init()
    }
}
