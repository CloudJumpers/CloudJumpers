//
//  SKPhysicsBodyFactory.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import SpriteKit

class SKPhysicsBodyFactory {
    static func createPhysicsBody(shape: CollisionComponent.Shape) -> SKPhysicsBody{
        switch shape {
        case .player:
            return SKPhysicsBody(rectangleOf: CGSize(width: 0.1, height: 0.3))
        case .cloud:
            return SKPhysicsBody(rectangleOf: CGSize(width: 0.4, height: 0.1))
        case .platform:
            return SKPhysicsBody(rectangleOf: CGSize(width: 0.7, height: 0.1))

        }
    }
}
