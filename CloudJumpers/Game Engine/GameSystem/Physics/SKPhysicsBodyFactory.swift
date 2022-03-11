//
//  SKPhysicsBodyFactory.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import SpriteKit

class SKPhysicsBodyFactory {
    
    static func createPhysicsBody(shape: PhysicsComponent.Shape) -> SKPhysicsBody{
        var physicsBody: SKPhysicsBody

        switch shape {
        case .player:
            physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.1, height: 0.3))
        case .cloud:
            physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.4, height: 0.1))
        case .platform:
            physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.7, height: 0.1))
        }
        
        physicsBody.affectedByGravity = (shape == .player)
        physicsBody.collisionBitMask = 0b00001
        
        return physicsBody
        
    }
}
