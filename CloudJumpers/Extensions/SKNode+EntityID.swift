//
//  SKNode+ID.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 25/3/22.
//

import SpriteKit

extension SKNode {
    var entityID: EntityID? {
        get { name }
        set { name = newValue }
    }
}
