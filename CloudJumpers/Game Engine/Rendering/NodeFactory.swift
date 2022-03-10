//
//  NodeFactory.swift
//  CloudJumpers
//
//  Created by Trong Tan on 3/11/22.
//

import Foundation
import SpriteKit

class NodeFactory {
    static func createSpriteNode(from component: RenderingComponent) -> SKSpriteNode {
        switch component.type {
        case .sprite(name: let name):
            return SKSpriteNode(imageNamed: name)
        case .background:
            return SKSpriteNode(imageNamed: "background")
        }
    }
}
