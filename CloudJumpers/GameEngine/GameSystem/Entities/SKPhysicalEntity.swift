//
//  SKPhysicalEntity.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/18/22.
//

import SpriteKit

class SKPhysicalEntity: SKEntity {
    var physicsBody: SKPhysicsBody?

    func linkPhysicsBodyToNode() {
        self.node?.physicsBody = self.physicsBody
    }
    func createSKPhysicsBody() -> SKPhysicsBody? {
        nil
    }
}
