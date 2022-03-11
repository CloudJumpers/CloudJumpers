//
//  SKNodeFactory.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import SpriteKit

class SKNodeFactory {
    
    static func createSKSpriteNode(type: RenderingComponent.SpriteType) -> SKSpriteNode {
        switch type {
        case .sprite(let position, let name):
            return SKSpriteNode(imageNamed: name)
        case .background:
            return SKSpriteNode(imageNamed: "background")
        }
    }
    

}
