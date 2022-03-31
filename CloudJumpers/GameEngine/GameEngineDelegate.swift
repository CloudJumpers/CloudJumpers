//
//  GameEngineDelegate.swift
//  CloudJumpers
//
//  Created by Phillmont Muktar on 19/3/22.
//

import SpriteKit

protocol GameEngineDelegate: AnyObject {
    func engine(_ engine: GameEngine, addNode node: SKNode)
    func engine(_ engine: GameEngine, addStaticNode node: SKNode)
    func engine(_ engine: GameEngine, bindCameraTo node: SKNode)
}

extension GameEngineDelegate {
    func engine(_ engine: GameEngine, addNode node: SKNode) { }
    func engine(_ engine: GameEngine, addStaticNode node: SKNode) { }
    func engine(_ engine: GameEngine, bindCameraTo node: SKNode) { }
}
