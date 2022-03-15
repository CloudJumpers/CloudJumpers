//
//  ContactComponent.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/15/22.
//

import SpriteKit

class ContactComponent: Component {
    let nodeA: SKNode
    let nodeB: SKNode
    let contactType: ContactType
    
    init (nodeA: SKNode, nodeB: SKNode, type: ContactType) {
        self.nodeA = nodeA
        self.nodeB = nodeB
        self.contactType = type
    }

    enum ContactType {
        case begin, end
    }
}
